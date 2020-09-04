namespace :makoto do
  namespace :fairy do
    desc 'update fairy'
    task :update do
      Makoto::Fairy.refresh
      puts "#{Makoto::Fairy.count} fairies"
    end
  end
end
