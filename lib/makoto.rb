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
require 'sidekiq'
require 'sidekiq-scheduler'
require 'yaml'
require 'ginseng'
require 'ginseng/postgres'

module Makoto
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Environment
  autoload :Listener
  autoload :Logger
  autoload :HTTP
  autoload :Mastodon
  autoload :Package
  autoload :Postgres
  autoload :Random
  autoload :Responder
  autoload :Slack
  autoload :Template
  autoload :Worker

  # models
  autoload :Account, 'makoto/model/account'
  autoload :Form, 'makoto/model/form'
  autoload :Quote, 'makoto/model/quote'
  autoload :Series, 'makoto/model/series'
  autoload :Track, 'makoto/model/track'

  autoload_under 'daemon' do
    autoload :ListenerDaemon
    autoload :SidekiqDaemon
    autoload :ThinDaemon
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
    autoload :RespondWorker
    autoload :TrackRefreshWorker
    autoload :QuoteRefreshWorker
  end
end

Sidekiq.configure_client do |config|
  config.redis = {url: Makoto::Config.instance['/sidekiq/redis/dsn']}
end
Sidekiq.configure_server do |config|
  config.redis = {url: Makoto::Config.instance['/sidekiq/redis/dsn']}
end

Makoto::Postgres.connect
