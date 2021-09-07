module Mulukhiya
  extend Rake::DSL

  namespace :makoto do
    namespace :quote do
      desc 'update quotes'
      task :update do
        Quote.refresh
        puts "#{Quote.count} quotes"
      end
    end
  end
end


