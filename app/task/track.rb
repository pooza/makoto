namespace :makoto do
  namespace :track do
    desc 'update tracks'
    task :update do
      Makoto::Postgres.connect
      Makoto::Track.refresh
      puts "#{Makoto::Track.count} tracks"
    end
  end
end
