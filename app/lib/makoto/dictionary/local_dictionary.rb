module Makoto
  class LocalDictionary < Dictionary
    def initialize
      super
      @entries = []
      @http = HTTP.new
    end

    def name
      return config['/word/dic/filename']
    end

    def csv
      return @entries.map(&:to_csv).join
    end

    def count
      return @entries.count
    end

    def refresh
      @http.get(uri).each do |entry|
        @entries.push(entry)
      end
      save_dic
    end

    private

    def save_csv
      File.write(temp_csv_path, csv)
    end

    def uri
      return Ginseng::URI.parse(config['/word/url'])
    end
  end
end
