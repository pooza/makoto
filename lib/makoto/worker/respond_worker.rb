module Makoto
  class RespondWorker < Worker
    def perform(params)
      template = Template.new('toot')
      template[:account] = params['account']
      template[:message] = MessageBuilder.new(params).build
      mastodon.toot(
        status: template.to_s,
        visibility: params['visibility'],
        in_reply_to_id: params['toot_id'],
      )
    end
  end
end
