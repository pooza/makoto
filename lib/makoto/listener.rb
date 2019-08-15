require 'sanitize'
require 'eventmachine'
require 'faye/websocket'

module Makoto
  class Listener
    attr_reader :client

    def open(e)
      @logger.info({class: self.class.to_s, uri: @uri.to_s, action: 'start'})
    end

    def close(e)
      @logger.info({class: self.class.to_s, action: 'close'})
    end

    def error(e)
      Slack.broadcast(e)
      @logger.error(e)
    end

    def receive(message)
      data = JSON.parse(message.data)
      return unless data['event'] == 'notification'
      return unless payload = JSON.parse(data['payload'])
      return unless payload['type'] == 'mention'
      template = Template.new('toot')
      template[:account] = payload['account']['acct']
      template[:message] = Sanitize.clean(payload['status']['content']).gsub(/@[[:word:]]+/, '')
      Slack.broadcast({body: template.to_s, visibility: payload['status']['visibility']})
      @mastodon.toot(status: template.to_s, visibility: payload['status']['visibility'])
    rescue => e
      Slack.broadcast(e)
      @logger.error(e)
    end

    def self.start
      EM.run do
        listener = Listener.new

        listener.client.on :open do |e|
          listener.open(e)
        end

        listener.client.on :error do |e|
          listener.error(e)
        end

        listener.client.on :close do |e|
          listener.close(e)
          exit
        end

        listener.client.on :message do |message|
          listener.receive(message)
        end
      end
    end

    private

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'])
      @mastodon.token = @config['/mastodon/token']
      @uri = @mastodon.create_streaming_uri
      @client = Faye::WebSocket::Client.new(@uri.to_s)
      @logger = Logger.new
    end
  end
end
