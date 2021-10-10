module Makoto
  class MakotoListener < Listener
    def receive(message)
      data = JSON.parse(message.data)
      payload = JSON.parse(data['payload'])
      if data['event'] == 'notification'
        send("handle_#{payload['type']}_notification".to_sym, payload)
      else
        send("handle_#{data['event']}".to_sym, payload)
      end
    rescue NoMethodError
      logger.error(error: 'method undefined', payload: payload)
    rescue => e
      logger.error(error: e, payload: (payload rescue message.data))
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

    def self.start
      EM.run do
        listener = MakotoListener.new

        listener.client.on :close do |e|
          raise Ginseng::GatewayError, e.message
        end

        listener.client.on :error do |e|
          raise Ginseng::GatewayError, e.message
        end

        listener.client.on :message do |message|
          listener.receive(message)
        end
      end
    rescue => e
      @client = nil
      logger.error(error: e)
      sleep(5)
      retry
    end
  end
end
