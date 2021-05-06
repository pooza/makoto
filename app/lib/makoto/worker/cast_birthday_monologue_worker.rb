module Makoto
  class CastBirthdayMonologueWorker < Worker
    def perform
      casts.each do |cast|
        template = Template.new('cast_birthday')
        template[:cast] = cast
        mastodon.toot(status: template.to_s, visibility: visibility)
      end
    end

    def casts
      return RubicureAPIService.instance.girls.select do |girl|
        next unless girl['cast_birthday']
        next unless date = Date.parse("#{Date.today.year}/#{girl['cast_birthday']}")
        date.today?
      end
    end
  end
end
