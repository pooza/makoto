module Makoto
  class Form < Sequel::Model(:form)
    one_to_many :quote

    def self.get(name)
      return Form.first(name: name.nfkc) || Form.create(name: name.nfkc)
    end
  end
end
