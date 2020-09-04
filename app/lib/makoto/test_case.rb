require 'sidekiq/testing'

module Makoto
  class TestCase < Ginseng::TestCase
    def self.load
      ENV['TEST'] = Package.name
      Sidekiq::Testing.fake!
      names.each do |name|
        puts "case: #{name}"
        require File.join(dir, "#{name}.rb")
      end
    end

    def self.names
      names = ARGV.first.split(/[^[:word:],]+/)[1]&.split(',')
      names ||= Dir.glob(File.join(dir, '*.rb')).map {|v| File.basename(v, '.rb')}
      TestCaseFilter.all do |filter|
        filter.exec(names) if filter.active?
      end
      return names.sort.uniq
    end

    def self.dir
      return File.join(Environment.dir, 'test')
    end
  end
end
