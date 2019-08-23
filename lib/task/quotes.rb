namespace :makoto do
  namespace :quote do
    namespace :dictionary do
      desc 'update quote dictionary'
      task :update do
        dic = Makoto::QuoteDictionary.new
        dic.delete if dic.exist?
        dic.create
        puts "path: #{dic.path}"
        puts "#{dic.count} quotes"
      end
    end
  end
end
