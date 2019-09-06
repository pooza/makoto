require 'eventmachine'
require 'faye/websocket'
require 'sanitize'
require 'unicode'

module Makoto
  class Listener
    attr_reader :client
    attr_reader :uri

    def open
      @logger.info(class: self.class.to_s, uri: @uri.to_s, action: 'start')
    end

    def error(error)
      Slack.broadcast(error)
      @logger.error(error)
    end

    def receive(message)
      data = JSON.parse(message.data)
      payload = JSON.parse(data['payload'])
      if data['event'] == 'notification'
        send("handle_#{payload['type']}_notification".to_sym, payload)
      else
        send("handle_#{data['event']}".to_sym, payload)
      end
    rescue NoMethodError => e
      @logger.error(e)
    rescue => e
      message = Ginseng::Error.create(e).to_h
      message.merge!(payload: payload) if payload
      Slack.broadcast(message)
      @logger.error(message)
    end

    def handle_mention_notification(payload)
      RespondWorker.perform_async(
        account: payload['account']['acct'],
        toot_id: payload['status']['id'],
        content: create_content(payload['status']),
        visibility: payload['status']['visibility'],
      )
    end

    def handle_follow_notification(payload)
      FollowWorker.perform_async(
        account_id: payload['account']['id'],
      )
    end

    def handle_update(payload)
      return unless respondable?(payload)
      RespondWorker.perform_async(
        account: payload['account']['acct'],
        toot_id: payload['id'],
        content: create_content(payload),
        visibility: payload['visibility'],
      )
    end

    def handle_delete(payload); end

    def create_content(status)
      tags = []
      content = Unicode.nfkc(Sanitize.clean(status['content']))
      @config['/reply/topics'].each do |topic|
        tags.push(Mastodon.create_tag(topic)) if content.include?(topic)
      end
      return "#{content} #{tags.join(' ')}"
    end

    def respondable?(payload)
      return false if @config['/reply/ignore_accounts'].include?(payload['account']['acct'])
      content = Unicode.nfkc(Sanitize.clean(payload['content']))
      return false if content.match(Regexp.new("@#{@config['/reply/me']}(\\s|$)"))
      @config['/reply/topics'].each do |topic|
        return true if content.include?(topic)
      end
      return false
    end

    def self.start
      EM.run do
        listener = Listener.new

        listener.client.on :open do |e|
          listener.open
        end

        listener.client.on :close do |e|
          raise 'closed'
        end

        listener.client.on :error do |e|
          listener.error(e)
        end

        listener.client.on :message do |message|
          listener.receive(message)
        end
      end
    rescue => e
      Slack.broadcast(e)
      retry
    end

    private

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
      @uri = @mastodon.create_streaming_uri
      @client = Faye::WebSocket::Client.new(@uri.to_s, nil, {
        ping: @config['/websocket/keepalive'],
      })
      @logger = Logger.new
    end
  end
end
