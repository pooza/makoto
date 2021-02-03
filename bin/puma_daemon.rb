#!/usr/bin/env ruby

dir = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

require 'makoto'
module Makoto
  config = Config.instance
  ENV['RACK_ENV'] ||= config['/environment']
  PumaDaemon.spawn!
end
