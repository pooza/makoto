namespace :makoto do
  namespace :fairy do
    desc 'update fairy'
    task :update do
      Makoto::Postgres.connect
      Makoto::Fairy.refresh
      puts "#{Makoto::Fairy.count} fairies"
    end
  end
end
