module Makoto
  class RespondWorker < Worker
    sidekiq_options retry: 3

    def initialize
      super
      @container = ResponseContainer.new
    end

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
      @container.clear
      Responder.all do |responder|
        responder.params = params
        next unless responder.executable?
        responder.exec
        @account.fav!(responder.favorability)
        logger.info(responder: responder.underscore, source: responder.source)
        @container.paragraphs.concat(responder.paragraphs)
        @container.greetings.concat(responder.greetings)
        break unless responder.continue?
      rescue MatchingError
        return nil unless params['mention']
      end
      return han2zen(@container.to_s)
    rescue => e
      logger.error(error: e)
      return FixedResponder.new.exec[:paragraphs].join
    end

    def han2zen(message)
      message.tr!('!', '！')
      message.tr!('?', '？')
      message.tr!('~', '〜')
      message.gsub!('！{2,}', '!!')
      message.gsub!('！？', '!?')
      message.gsub!('？！', '?!')
      return message
    end

    def max
      return config['/respond/paragraph/max']
    end

    def min
      return config['/respond/paragraph/min']
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
      logger.info(class: self.class.to_s, words: result)
    end
  end
end
