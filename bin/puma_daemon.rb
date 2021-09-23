#!/usr/bin/env ruby

dir = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

require 'makoto'
module Makoto
  ENV['RACK_ENV'] ||= Environment.type
  PumaDaemon.spawn!
end
