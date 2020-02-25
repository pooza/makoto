require 'unicode'

module Makoto
  class Form < Sequel::Model(:form)
    one_to_many :quote

    def self.get(name)
      name = Unicode.nfkc(name)
      unless form = Form.first(name: name)
        form = Form.create(name: name)
      end
      return form
    end
  end
end
