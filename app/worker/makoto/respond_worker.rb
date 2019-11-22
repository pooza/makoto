module Makoto
  class RespondWorker < Worker
    sidekiq_options retry: 3

    def perform(params)
      template = Template.new('respond')
      account = Account.get(params['account']['acct'])
      template[:account] = account.acct
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
        next unless responder.executable?
        @logger.info(responder: responder.class.to_s)
        Account.get(params['account']['acct']).fav!(responder.fav)
        return responder.exec
      end
      raise 'All responders are not executable!'
    rescue => e
      @logger.error(e)
      return FixedResponder.new.exec
    end
  end
end
