require 'bootsnap'
require 'sidekiq'
require 'sidekiq-scheduler'
require 'ginseng'

module Makoto
  def self.dir
    return File.expand_path('../..', __dir__)
  end

  def self.bootsnap
    Bootsnap.setup(
      cache_dir: File.join(dir, 'tmp/cache'),
      load_path_cache: true,
      autoload_paths_cache: true,
      compile_cache_iseq: true,
      compile_cache_yaml: true,
    )
  end

  def self.loader
    config = YAML.load_file(File.join(dir, 'config/autoload.yaml'))
    loader = Zeitwerk::Loader.new
    loader.inflector.inflect(config['inflections'])
    loader.push_dir(File.join(dir, 'app/lib'))
    config['dirs'].each do |d|
      loader.push_dir(File.join(dir, 'app', d))
    end
    loader.setup
  end

  def self.sidekiq
    Sidekiq.configure_client do |config|
      config.redis = {url: Config.instance['/sidekiq/redis/dsn']}
    end
    Sidekiq.configure_server do |config|
      config.redis = {url: Config.instance['/sidekiq/redis/dsn']}
    end
  end

  def self.rack
    require 'sidekiq/web'
    require 'sidekiq-scheduler/web'

    config = Makoto::Config.instance
    if config['/sidekiq/auth/user'].present? && config['/sidekiq/auth/password'].present?
      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        Makoto::Environment.auth(username, password)
      end
    end
    return Rack::URLMap.new('/makoto/sidekiq' => Sidekiq::Web)
  end
end

Makoto.bootsnap
Makoto.loader
Makoto.sidekiq
