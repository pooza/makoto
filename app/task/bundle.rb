module Makoto
  extend Rake::DSL

  namespace :bundle do
    desc 'update gems'
    task :update do
      sh 'bundle update'
    end

    desc 'install bundler'
    task :install_bundler do
      sh 'gem install bundler'
    end

    desc 'check gems'
    task check: [:install_bundler] do
      unless Environment.gem_fresh?
        warn 'gems is not fresh.'
        exit 1
      end
    end
  end
end
