module Makoto
  class Form < Sequel::Model(:form)
    include Package
    one_to_many :quote

    def self.ids(names = nil)
      return (names || config['/quote/default_forms']).filter_map do |name|
        Form.first(name: name)
      end.map(&:id)
    end

    def self.get(name)
      return Form.first(name: name.nfkc) || Form.create(name: name.nfkc)
    end
  end
end
