require 'csv'
require 'fileutils'

module Makoto
  class NeologdDictionary
    def initialize
      @config = Config.instance
    end

    def refresh
      save_csv
      save_dic
    end

    def install
      FileUtils.move(temp_dic_path, path)
    end

    def count
      return csv.each_line.count
    end

    def csv
      save_csv unless File.exist?(temp_csv_path)
      return File.read(temp_csv_path)
    end

    def path
      return File.join(user_dic_dir_path, 'neologd.dic')
    end

    private

    def save_csv
      Dir.chdir(neologd_repos_path)
      cmd = Ginseng::CommandLine.new(['git', 'pull'])
      cmd.exec
      raise cmd.stderr unless cmd.status.zero?
      src = Dir.glob(File.join(neologd_repos_path, 'seed/mecab-user-dict-seed.*.xz')).first
      dest = temp_csv_path + '.xz'
      FileUtils.copy(src, dest)
      cmd = Ginseng::CommandLine.new(['xz', '-dvf', dest])
      cmd.exec
      raise cmd.stderr unless cmd.status.zero?
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

    alias save save_dic

    def temp_csv_path
      return File.join(temp_dir_path, 'neologd.csv')
    end

    def temp_dic_path
      return File.join(temp_dir_path, 'neologd.dic')
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
