require 'csv'
require 'fileutils'

module Makoto
  class Dictionary
    def initialize
      @config = Config.instance
    end

    def name
      return self.class.to_s.split('::').last.sub(/Dictionary$/, '').underscore
    end

    def refresh
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    alias save refresh

    def install
      FileUtils.move(temp_dic_path, path)
    end

    def csv
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def count
      return csv.each_line.count
    end

    def path
      return File.join(user_dic_dir_path, "#{name}.dic")
    end

    private

    def save_csv
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def save_dic
      save_csv unless File.exist?(temp_csv_path)
      cmd = Ginseng::CommandLine.new([
        @config['/mecab/dic/bin'],
        '-d', system_dic_dir_path,
        '-u', temp_dic_path,
        '-f', 'utf8',
        '-t', 'utf8',
        temp_csv_path
      ])
      cmd.exec
      raise cmd.stderr unless cmd.status.zero?
    ensure
      File.unlink(temp_csv_path) if File.exist?(temp_csv_path)
    end

    def temp_csv_path
      return File.join(temp_dir_path, "#{name}.csv")
    end

    def temp_dic_path
      return File.join(temp_dir_path, "#{name}.dic")
    end

    def temp_dir_path
      return File.join(Environment.dir, 'tmp/cache')
    end

    def neologd_repos_path
      return @config['/mecab/dic/neologd/repos']
    end

    def system_dic_dir_path
      return @config['/mecab/dic/system']
    end

    def user_dic_dir_path
      return @config['/mecab/dic/user']
    end
  end
end
