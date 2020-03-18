require 'unicode'

module Makoto
  class Series < Sequel::Model(:series)
    one_to_many :quote

    def self.get(name)
      name = Unicode.nfkc(name)
      return Series.first(name: name) || Series.create(name: name)
    end
  end
end
