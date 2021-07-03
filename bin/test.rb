#!/usr/bin/env ruby
dir = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

require 'makoto'
module Makoto
  puts Package.name
  puts 'テストローダー'
  puts ''
  TestCase.load(ARGV.getopts('', 'cases:')['cases'])
rescue => e
  warn e.message
  exit 1
end
