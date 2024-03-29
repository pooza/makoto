module Makoto
  extend Rake::DSL

  namespace :makoto do
    namespace :message do
      desc 'update message'
      task :update do
        Message.refresh
        puts "#{Message.count} messages"
      end
    end
  end
end
