require 'unicode'

module Makoto
  class Lib < Array
    def initialize
      super
      @logger = Logger.new
      @config = Config.instance
      @http = HTTP.new
      refresh unless exist?
      load
    end

    def exist?
      return File.exist?(path)
    end

    def underscore_name
      return self.class.to_s.split('::').last.sub(/Lib$/, '').underscore
    end

    def path
      return File.join(Environment.dir, 'tmp/cache', "#{underscore_name}_lib")
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

    def delete
      File.unlink(path) if exist?
    end

    def fetch
      return @http.get(@config["/#{underscore_name}/url"]).parsed_response
    end

    def create_pattern(word)
      pattern = Unicode.nfkc(word.to_s).gsub(/[^[:alnum:]]/, '.? ?')
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
