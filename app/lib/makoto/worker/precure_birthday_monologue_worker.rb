module Makoto
  class PrecureBirthdayMonologueWorker < Worker
    def perform
      return if girls.empty?
      template = Template.new('precure_birthday')
      template[:girls] = girls
      mastodon.toot(status: template.to_s, visibility: visibility)
    end

    def girls
      return RubicureAPIService.instance.girls.select do |girl|
        next unless girl['birthday']
        next unless date = Date.parse("#{Date.today.year}/#{girl['birthday']}")
        date.today?
      end
    end
  end
end
