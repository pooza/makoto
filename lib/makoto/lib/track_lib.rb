require 'unicode'

module Makoto
  class TrackLib < Lib
    def tracks(params = {})
      tracks = clone.keep_if{|v| keep?(v, params)}
      return tracks if params[:detail].present?
      return tracks.map{|v| v['url']}.uniq
    end

    def keep?(entry, params = {})
      params[:title] ||= ''
      pattern = create_pattern(params[:title])
      return false if !entry['makoto'].present? && params[:makoto]
      return false if !entry['title'].match(pattern) && params[:title]
      return true
    end

    def create_pattern(word)
      pattern = Unicode.nfkc(word).gsub(/[^[:alnum:]]/, '.? ?')
      [
        'あぁ', 'いぃ', 'うぅ', 'えぇ', 'おぉ', 'やゃ', 'ゆゅ', 'よょ',
        'アァ', 'イィ', 'ウゥ', 'エェ', 'オォ', 'ヤャ', 'ユュ', 'ヨョ'
      ].each do |v|
        pattern.gsub!(Regexp.new("[#{v}]"), "[#{v}]")
      end
      return Regexp.new(pattern)
    end
  end
end
