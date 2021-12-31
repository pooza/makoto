#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.join(File.expand_path('..', __dir__), 'app/lib'))
ENV['RAKE'] = nil

require 'makoto'
module Makoto
  ENV['RACK_ENV'] ||= Environment.type
  PumaDaemon.spawn!
end
