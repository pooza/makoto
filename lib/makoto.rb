require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'
require 'ginseng'
require 'sidekiq'
require 'sidekiq-scheduler'
require 'yaml'

module Makoto
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Environment
  autoload :Lib
  autoload :Listener
  autoload :Logger
  autoload :HTTP
  autoload :Mastodon
  autoload :Package
  autoload :Responder
  autoload :Slack
  autoload :TagContainer
  autoload :Template
  autoload :Worker

  autoload_under 'daemon' do
    autoload :ListenerDaemon
    autoload :SidekiqDaemon
    autoload :ThinDaemon
  end

  autoload_under 'lib' do
    autoload :QuoteLib
    autoload :TrackLib
  end

  autoload_under 'responder' do
    autoload :BadMoodResponder
    autoload :CureSwordResponder
    autoload :DentalResponder
    autoload :FixedResponder
    autoload :GreetingResponder
    autoload :KeywordResponder
    autoload :PrincessResponder
    autoload :SongResponder
  end

  autoload_under 'worker' do
    autoload :FollowWorker
    autoload :FollowMaintenanceWorker
    autoload :GoodMorningMonologueWorker
    autoload :GoodQuoteMonologueWorker
    autoload :NowplayingMonologueWorker
    autoload :QuoteLibWorker
    autoload :RespondWorker
    autoload :TrackLibWorker
  end
end

Sidekiq.configure_client do |config|
  config.redis = {url: Makoto::Config.instance['/sidekiq/redis/dsn']}
end
Sidekiq.configure_server do |config|
  config.redis = {url: Makoto::Config.instance['/sidekiq/redis/dsn']}
end
