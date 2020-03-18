require 'unicode'

module Makoto
  class Form < Sequel::Model(:form)
    one_to_many :quote

    def self.get(name)
      name = Unicode.nfkc(name)
      return Form.first(name: name) || Form.create(name: name)
    end
  end
end
