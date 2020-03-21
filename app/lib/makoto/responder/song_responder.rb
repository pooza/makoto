module Makoto
  class SongResponder < Responder
    def executable?
      pattern = Regexp.new(@config['/respond/song/pattern'])
      return false unless matches = source_text.match(pattern)
      @title = matches[1]
      return @title.present?
    end

    def favorability
      return rand(1..2)
    end

    def exec
      track = Track.pickup(title: @title)
      return @config['/respond/song/response/error'].sample % [@title] unless track
      @template = Template.new('nowplaying')
      @template[:greeting] = @config['/respond/song/response/normal'].sample
      unless track.makoto?
        @template[:greeting] += @config['/respond/song/response/other_singer'].sample
      end
      @template[:url] = track.url
      @template[:intro] = track.intro
      return @template.to_s
    end
  end
end
