module Makoto
  class PrecureBirthdayMonologueWorker < Worker
    def perform
      return if girls.empty?
      girls.each do |girl|
        template = Template.new('precure_birthday')
        template[:girl] = girl
        mastodon.toot(status: template.to_s, visibility:)
      end
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
