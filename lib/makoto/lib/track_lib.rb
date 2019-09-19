module Makoto
  class TrackLib < Lib
    def tracks(params = {})
      tracks = clone.keep_if{|v| keep?(v, params)}
      return tracks if params[:detail].present?
      return tracks.map{|v| v['url']}.uniq
    end

    def keep?(entry, params = {})
      return false if !entry['makoto'].present? && params[:makoto]
      return false unless entry['title'].match(create_pattern(params[:title]))
      return true
    end
  end
end
