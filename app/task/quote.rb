namespace :makoto do
  namespace :quote do
    desc 'update quotes'
    task :update do
      Makoto::Quote.refresh
      puts "#{Makoto::Quote.count} quotes"
    end
  end
end
