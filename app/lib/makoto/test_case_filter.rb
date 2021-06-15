module Makoto
  class TestCaseFilter < Ginseng::TestCaseFilter
    include Package

    def self.create(name)
      return all.find {|v| v.name == name}
    end

    def self.all
      return enum_for(__method__) unless block_given?
      config.raw.dig('test', 'filters').each do |entry|
        yield "Makoto::#{entry['name'].camelize}TestCaseFilter".constantize.new(entry)
      end
    end
  end
end
