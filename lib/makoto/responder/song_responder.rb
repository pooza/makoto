module Makoto
  class SongResponder < Responder
    def executable?
      pattern = Regexp.new(@config['/respond/song/pattern'])
      return false unless matches = @params['content'].match(pattern)
      @title = matches[2] || matches[1]
      return @title.present?
    end

    def exec
      tracks = @tracks.tracks(detail: true, title: @title)
      return @config['/respond/song/response/error'].sample % [@title] unless tracks.present?
      @template = Template.new('nowplaying')
      @template[:greeting] = @config['/respond/song/response/normal'].sample
      track = tracks.first
      unless track['makoto'].present?
        @template[:greeting] += @config['/respond/song/response/other_singer'].sample
      end
      @template[:url] = track['url']
      return @template.to_s
    end
  end
end
