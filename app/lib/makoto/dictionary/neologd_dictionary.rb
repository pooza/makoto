module Makoto
  class NeologdDictionary < Dictionary
    def csv
      save_csv unless File.exist?(temp_csv_path)
      return File.read(temp_csv_path)
    end

    def refresh
      save_csv
      save_dic
    end

    private

    def save_csv
      git_pull
      extract
    end

    def git_pull
      Dir.chdir(neologd_repos_path)
      cmd = Ginseng::CommandLine.new(['git', 'pull'])
      cmd.exec
      raise cmd.stderr unless cmd.status.zero?
    end

    def extract
      FileUtils.copy(src_xz_path, temp_xz_path)
      cmd = Ginseng::CommandLine.new(['xz', '-dvf', temp_xz_path])
      cmd.exec
      raise cmd.stderr unless cmd.status.zero?
    end

    def neologd_repos_path
      return config['/mecab/dic/neologd/repos']
    end

    def src_xz_path
      return Dir.glob(File.join(neologd_repos_path, 'seed/mecab-user-dict-seed.*.xz')).first
    end

    def temp_xz_path
      return "#{temp_csv_path}.xz"
    end
  end
end
