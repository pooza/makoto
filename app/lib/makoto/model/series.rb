module Makoto
  class Series < Sequel::Model(:series)
    one_to_many :quote

    def self.get(name)
      return Series.first(name: name.nfkc) || Series.create(name: name.nfkc)
    end
  end
end
