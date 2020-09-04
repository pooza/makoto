namespace :makoto do
  namespace :message do
    desc 'update message'
    task :update do
      Makoto::Message.refresh
      puts "#{Makoto::Message.count} messages"
    end
  end
end
