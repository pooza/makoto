module Makoto
  class GoodMorningMonologueWorker < Worker
    sidekiq_options retry: 3

    def perform
      template = Template.new('good_morning')
      template[:holiday_messages] = holiday_messages
      template[:greeting] = greeting
      mastodon.toot(status: template.to_s, visibility:)
    end

    def greeting
      return Message.pickup(type: 'morning', season: Time.now.month).message
    end

    def holiday_messages
      return Message.dataset.where(
        type: 'holiday',
        month: Time.now.month,
        day: Time.now.day,
      ).all.map(&:message)
    end
  end
end
