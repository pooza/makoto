require 'csv'
require 'fileutils'

module Makoto
  class Dictionary < Array
    def initialize(size = 0, val = nil)
      super(size, val)
      @config = Config.instance
    end

    def refresh
      fetch{|entry| push(entry)}
      File.write(File.join(temp_path, 'makoto.csv'), csv)
      cmd = Ginseng::CommandLine.new
      cmd.args = [
        @config['/mecab/dict-index_bin'],
        '-d', @config['/mecab/dict_path'],
        '-u', File.join(temp_path, 'makoto.dic'),
        '-f', 'utf8',
        '-t', 'utf8',
        File.join(temp_path, 'makoto.csv')
      ]
      cmd.exec
      raise cmd.stderr unless cmd.status.zero?
    end

    def install
      src = File.join(temp_path, 'makoto.dic')
      dest = File.join(path, 'makoto.dic')
      FileUtils.move(src, dest)
    end

    def csv
      return map(&:to_csv).join
    end

    def fetch
      return enum_for(__method__) unless block_given?
      HTTP.new.get(uri).each do |entry|
        yield entry
      end
    end

    def uri
      return URI.parse(@config['/word/url'])
    end

    def temp_path
      return File.join(Environment.dir, 'tmp/cache')
    end

    def path
      return @config['/mecab/userdict_path']
    end
  end
end
