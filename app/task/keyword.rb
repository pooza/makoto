namespace :makoto do
  namespace :keyword do
    desc 'update keyword'
    task :update do
      Makoto::Keyword.refresh
      puts "#{Makoto::Keyword.count} keywords"
    end
  end
end
