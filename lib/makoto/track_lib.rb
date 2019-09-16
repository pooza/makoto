require 'unicode'

module Makoto
  class TrackLib < Array
    def initialize
      super
      @logger = Logger.new
      @config = Config.instance
      @http = HTTP.new
      load
    end

    def exist?
      return File.exist?(path)
    end

    def path
      return File.join(Environment.dir, 'tmp/cache/track_lib')
    end

    def load
      return unless exist?
      clear
      concat(Marshal.load(File.read(path)))
    end

    def refresh
      File.write(path, Marshal.dump(fetch))
      load
    rescue => e
      @logger.error(e)
    end

    alias create refresh

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

    def delete
      File.unlink(path) if exist?
    end

    def fetch
      return @http.get(@config['/track/url']).parsed_response
    end
  end
end
