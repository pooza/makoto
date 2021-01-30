require 'sidekiq/testing'

module Makoto
  class TestCase < Ginseng::TestCase
    include Package

    def self.load
      ENV['TEST'] = Package.name
      Sidekiq::Testing.fake!
      names.each do |name|
        puts "case: #{name}"
        require File.join(dir, "#{name}.rb")
      end
    end

    def self.names
      if arg = ARGV.first.split(/[^[:word:],]+/)[1]
        names = []
        arg.split(',').each do |name|
          names.push(name) if File.exist?(File.join(dir, "#{name}.rb"))
          names.push("#{name}_test") if File.exist?(File.join(dir, "#{name}_test.rb"))
        end
      end
      names ||= Dir.glob(File.join(dir, '*.rb')).map {|v| File.basename(v, '.rb')}
      TestCaseFilter.all do |filter|
        next unless filter.active?
        puts "filter: #{filter.class}" if Environment.test?
        filter.exec(names)
      end
      return names.uniq.sort
    end

    def self.dir
      return File.join(Environment.dir, 'test')
    end
  end
end
