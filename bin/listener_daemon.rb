#!/usr/bin/env ruby

dir = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'makoto'

config = Makoto::Config.instance
ENV['RACK_ENV'] ||= config['/environment']

Makoto::ListenerDaemon.spawn!
