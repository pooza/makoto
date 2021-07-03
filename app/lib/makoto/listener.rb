require 'eventmachine'
require 'faye/websocket'

module Makoto
  class Listener
    include Package
    attr_reader :client, :uri

    def close(event)
      @client = nil
      e = Ginseng::GatewayError.new('close')
      e.message = {reason: event.reason}
      logger.error(error: e)
    end

    def error(event)
      @client = nil
      e = Ginseng::GatewayError.new('error')
      e.message = {reason: event.reason}
      logger.error(error: e)
    end

    def receive(message)
      data = JSON.parse(message.data)
      payload = JSON.parse(data['payload'])
      if data['event'] == 'notification'
        send("handle_#{payload['type']}_notification".to_sym, payload)
      else
        send("handle_#{data['event']}".to_sym, payload)
      end
    rescue => e
      logger.error(error: e, payload: payload)
    end

    def handle_mention_notification(payload)
      RespondWorker.perform_async(
        account: {
          acct: payload['account']['acct'],
          display_name: payload['account']['display_name'],
        },
        toot_id: payload['status']['id'],
        content: payload['status']['content'],
        visibility: payload['status']['visibility'],
        mention: true,
      )
    end

    def handle_follow_notification(payload)
      FollowWorker.perform_async(
        account_id: payload['account']['id'],
      )
    end

    def handle_update(payload)
      return unless Analyzer.respondable?(payload)
      RespondWorker.perform_async(
        account: {
          acct: payload['account']['acct'],
          display_name: payload['account']['display_name'],
        },
        toot_id: payload['id'],
        content: payload['content'],
        visibility: payload['visibility'],
      )
    end

    def handle_delete(payload)
    end

    def self.start
      EM.run do
        listener = Listener.new

        listener.client.on :close do |e|
          listener.close(e)
          raise 'closed'
        end

        listener.client.on :error do |e|
          listener.error(e)
          raise 'error'
        end

        listener.client.on :message do |message|
          listener.receive(message)
        end
      end
    rescue
      sleep(5)
      retry
    end

    private

    def initialize
      @mastodon = Mastodon.new(config['/mastodon/url'], config['/mastodon/token'])
      @uri = @mastodon.streaming_uri
      @client = Faye::WebSocket::Client.new(@uri.to_s, nil, {
        ping: config['/websocket/keepalive'],
      })
    end
  end
end
