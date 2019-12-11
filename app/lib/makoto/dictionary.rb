require 'csv'
require 'fileutils'

module Makoto
  class Dictionary < Array
    def initialize(size = 0, val = nil)
      super(size, val)
      @config = Config.instance
    end

    def refresh
      fetch do |entry|
        push(entry)
      end
      save
    end

    def install
      FileUtils.move(temp_dic_path, user_dic_path)
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

    def user_dic_path
      return File.join(user_dic_dir_path, 'makoto.dic')
    end

    private

    def save_csv
      File.write(temp_csv_path, csv)
    end

    def save_dic
      save_csv unless File.exist?(temp_csv_path)
      cmd = Ginseng::CommandLine.new
      cmd.args = [
        @config['/mecab/dic/bin'],
        '-d', system_dic_dir_path,
        '-u', temp_dic_path,
        '-f', 'utf8',
        '-t', 'utf8',
        temp_csv_path
      ]
      cmd.exec
      raise cmd.stderr unless cmd.status.zero?
    ensure
      File.unlink(temp_csv_path) if File.exist?(temp_csv_path)
    end

    alias save save_dic

    def uri
      return URI.parse(@config['/word/url'])
    end

    def temp_csv_path
      return File.join(temp_dir_path, 'makoto.csv')
    end

    def temp_dic_path
      return File.join(temp_dir_path, 'makoto.dic')
    end

    def temp_dir_path
      return File.join(Environment.dir, 'tmp/cache')
    end

    def system_dic_dir_path
      return @config['/mecab/dic/system']
    end

    def user_dic_dir_path
      return @config['/mecab/dic/user']
    end
  end
end
