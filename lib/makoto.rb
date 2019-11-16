require 'bootsnap'

Bootsnap.setup(
  cache_dir: File.join(File.expand_path('..', __dir__), 'tmp/cache'),
  load_path_cache: true,
  autoload_paths_cache: true,
  compile_cache_iseq: true,
  compile_cache_yaml: true,
)

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
  autoload :Random
  autoload :Responder
  autoload :Slack
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

  autoload_under 'model' do
    autoload :Account
    autoload :Form
    autoload :Track
    autoload :Quote
    autoload :Series
  end

  autoload_under 'responder' do
    autoload :BadMoodResponder
    autoload :CureSwordResponder
    autoload :FixedResponder
    autoload :GreetingResponder
    autoload :InterestedResponder
    autoload :KeywordResponder
    autoload :SongResponder
  end

  autoload_under 'worker' do
    autoload :BirthdayMonologueWorker
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
