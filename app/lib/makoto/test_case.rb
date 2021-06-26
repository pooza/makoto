require 'sidekiq/testing'

module Makoto
  class TestCase < Ginseng::TestCase
    include Package

    def test_account
      return {
        'acct' => config['/test/account/acct'],
        'display_name' => config['/test/account/display_name'],
      }
    end

    def self.load(cases = nil)
      ENV['TEST'] = Package.full_name
      Sidekiq::Testing.fake!
      names(cases).each do |name|
        puts "+ case: #{name}" if Environment.test?
        require File.join(dir, "#{name}.rb")
      rescue => e
        puts "- case: #{name} (#{e.message})" if Environment.test?
      end
    end

    def self.names(cases = nil)
      if cases
        names = []
        cases.split(',').each do |name|
          names.push(name) if File.exist?(File.join(dir, "#{name}.rb"))
          names.push("#{name}_test") if File.exist?(File.join(dir, "#{name}_test.rb"))
        end
      end
      names ||= Dir.glob(File.join(dir, '*.rb')).map {|v| File.basename(v, '.rb')}
      TestCaseFilter.all.select(&:active?).each {|v| v.exec(names)}
      return names.uniq.sort
    end

    def self.dir
      return File.join(Environment.dir, 'test')
    end
  end
end
