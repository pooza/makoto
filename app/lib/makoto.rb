require 'bootsnap'

Bootsnap.setup(
  cache_dir: File.join(File.expand_path('../..', __dir__), 'tmp/cache'),
  load_path_cache: true,
  autoload_paths_cache: true,
  compile_cache_iseq: true,
  compile_cache_yaml: true,
)

require 'active_support'
require 'active_support/core_ext'
require 'zeitwerk'
require 'sidekiq'
require 'sidekiq-scheduler'
require 'ginseng'

module Makoto
  def self.dir
    return File.expand_path('../..', __dir__)
  end

  def self.configure_autoload
    loader = Zeitwerk::Loader.new
    loader.inflector.inflect(
      'http' => 'HTTP',
    )
    loader.push_dir(File.join(dir, 'app/lib'))
    loader.push_dir(File.join(dir, 'app/daemon'))
    loader.push_dir(File.join(dir, 'app/model'))
    loader.push_dir(File.join(dir, 'app/responder'))
    loader.push_dir(File.join(dir, 'app/worker'))
    loader.setup
  end

  def self.configure_sidekiq
    Sidekiq.configure_client do |config|
      config.redis = {url: Config.instance['/sidekiq/redis/dsn']}
    end
    Sidekiq.configure_server do |config|
      config.redis = {url: Config.instance['/sidekiq/redis/dsn']}
    end
  end
end

Makoto.configure_autoload
Makoto.configure_sidekiq
