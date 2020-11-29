module Makoto
  class RespondWorker < Worker
    sidekiq_options retry: 3

    def perform(params)
      template = Template.new('respond')
      @account = Account.get(params['account']['acct'])
      params['analyzer'] = Analyzer.new(params['content'])
      template[:account] = @account.acct
      template[:message] = create_message(params)
      save(params['analyzer'].result)
      return if template[:message].nil? && params['mention'].nil?
      mastodon.toot(
        status: template.to_s,
        visibility: params['visibility'],
        in_reply_to_id: params['toot_id'],
      )
    end

    def create_message(params)
      sentences = []
      Responder.all do |responder|
        responder.params = params
        next unless responder.executable?
        @logger.info(responder: responder.class.to_s, source: Analyzer.sanitize(params['content']))
        Account.get(params['account']['acct']).fav!(responder.favorability)
        sentences.push(responder.exec)
        break unless responder.continue?
      rescue MatchingError => e
        @logger.info(error: e.message, source: Analyzer.sanitize(params['content']))
        return nil unless params['mention']
      end
      return sentences.join
    rescue => e
      @logger.error(e)
      return FixedResponder.new.exec
    end

    def save(result)
      return unless @account
      Postgres.instance.connection.transaction do
        result.each do |word|
          PastKeyword.create(
            account_id: @account.id,
            surface: word[:surface],
            feature: word[:feature],
            created_at: Time.new,
          )
        end
      end
      @logger.info(class: self.class.to_s, words: result)
    end
  end
end
