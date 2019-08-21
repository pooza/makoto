require 'eventmachine'
require 'faye/websocket'

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
      return unless data['event'] == 'notification'
      return unless payload = JSON.parse(data['payload'])
      return unless payload['type'] == 'mention'
      RepeatRespondWorker.perform_async(
        account: payload['account']['acct'],
        content: payload['status']['content'],
        visibility: payload['status']['visibility'],
      )
    rescue => e
      Slack.broadcast(e)
      @logger.error(e)
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
      @mastodon = Mastodon.new(@config['/mastodon/url'])
      @mastodon.token = @config['/mastodon/token']
      @uri = @mastodon.create_streaming_uri
      @client = Faye::WebSocket::Client.new(@uri.to_s, nil, {
        ping: @config['/websocket/keepalive'],
      })
      @logger = Logger.new
    end
  end
end
