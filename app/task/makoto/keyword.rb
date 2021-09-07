module Mulukhiya
  extend Rake::DSL

  namespace :makoto do
    namespace :keyword do
      desc 'update keyword'
      task :update do
        Keyword.refresh
        puts "#{Keyword.count} keywords"
      end
    end
  end
end
