#!/usr/bin/env ruby

path = File.expand_path(__FILE__)
path = File.expand_path(File.readlink(path)) while File.symlink?(path)
dir = File.expand_path('../..', path)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'makoto'
require 'eventmachine'
require 'faye/websocket'
require 'sanitize'

config = Makoto::Config.instance
mastodon = Makoto::Mastodon.new(config['/mastodon/url'])
mastodon.token = config['/mastodon/token']
uri = mastodon.create_streaming_uri
logger = Makoto::Logger.new

EM.run do
  client = Faye::WebSocket::Client.new(uri.to_s)

  client.on :open do |e|
    puts "open #{uri}"
  end

  client.on :error do |e|
    Makoto::Slack.broadcast(e)
    logger.error(e)
  end

  client.on :close do |e|
    puts "close #{uri}"
    exit
  end

  client.on :message do |message|
    data = JSON.parse(message.data)
    if data['event'] == 'notification'
      payload = JSON.parse(data['payload'])
      if payload['type'] == 'mention'
        template = Makoto::Template.new('toot')
        template[:account] = payload['account']['username']
        template[:message] = Sanitize.clean(payload['status']['content']).gsub(/@[[:word:]]+/, '')
        Makoto::Slack.broadcast({body: template.to_s, visibility: payload['status']['visibility']})
        mastodon.toot(status: template.to_s, visibility: payload['status']['visibility'])
      end
    end
  rescue => e
    Makoto::Slack.broadcast(e)
    logger.error(e)
  end
end
