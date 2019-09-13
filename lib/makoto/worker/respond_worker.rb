module Makoto
  class RespondWorker < Worker
    def perform(params)
      template = Template.new('respond')
      template[:account] = params['account']['acct']
      template[:message] = create_message(params)
      mastodon.toot(
        status: template.to_s,
        visibility: params['visibility'],
        in_reply_to_id: params['toot_id'],
      )
    end

    def create_message(params)
      Responder.all do |responder|
        responder.params = params
        return responder.exec if responder.executable?
      end
      raise 'All responders are not executable!'
    rescue => e
      @logger.error(e)
      return FixedResponder.new.exec
    end
  end
end
