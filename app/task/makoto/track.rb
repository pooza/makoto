module Makoto
  extend Rake::DSL

  namespace :makoto do
    namespace :track do
      desc 'update tracks'
      task :update do
        Track.refresh
        puts "#{Track.count} tracks"
      end
    end
  end
end


