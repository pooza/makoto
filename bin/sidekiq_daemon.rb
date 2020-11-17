#!/usr/bin/env ruby

dir = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

require 'makoto'
config = Makoto::Config.instance
ENV['RACK_ENV'] ||= config['/environment']
Makoto::SidekiqDaemon.spawn!
