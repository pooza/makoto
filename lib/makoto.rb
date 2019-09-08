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
  autoload :Listener
  autoload :Logger
  autoload :HTTP
  autoload :Mastodon
  autoload :MessageBuilder
  autoload :Package
  autoload :QuoteLib
  autoload :Slack
  autoload :TagContainer
  autoload :Template
  autoload :TrackLib

  autoload_under 'daemon' do
    autoload :ListenerDaemon
    autoload :SidekiqDaemon
    autoload :ThinDaemon
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
