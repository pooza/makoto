module Makoto
  extend Rake::DSL

  namespace :migration do
    desc 'migrate database'
    task :run do
      path = File.join(Environment.dir, 'app/migration')
      sh "bundle exec sequel -m #{path} '#{Postgres.dsn}' -E"
    end
  end

  desc 'alias of migration:run'
  task migrate: ['migration:run']
end
