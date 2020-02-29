namespace :makoto do
  namespace :keyword do
    desc 'update keyword'
    task :update do
      Makoto::Postgres.connect
      Makoto::Keyword.refresh
      puts "#{Makoto::Keyword.count} keywords"
    end
  end
end
