namespace :makoto do
  namespace :track do
    desc 'update tracks'
    task :update do
      Makoto::Track.refresh
      puts "#{Makoto::Track.count} tracks"
    end
  end
end
