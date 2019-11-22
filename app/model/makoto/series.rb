require 'unicode'

module Makoto
  class Series < Sequel::Model(:series)
    def self.get(name)
      name = Unicode.nfkc(name)
      unless series = Series.first(name: name)
        series = Series.create(name: name)
      end
      return series
    end
  end
end
