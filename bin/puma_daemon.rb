#!/usr/bin/env ruby

dir = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

Dir.chdir(dir)
require 'makoto'
module Makoto
  ENV['RACK_ENV'] ||= Environment.type
  PumaDaemon.spawn!
end
