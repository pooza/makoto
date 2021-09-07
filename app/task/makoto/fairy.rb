module Makoto
  extend Rake::DSL

  namespace :makoto do
    namespace :fairy do
      desc 'update fairy'
      task :update do
        Fairy.refresh
        puts "#{Fairy.count} fairies"
      end
    end
  end
end
