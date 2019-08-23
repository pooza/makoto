namespace :makoto do
  namespace :quote do
    desc 'update quotes'
    task :update do
      lib = Makoto::QuoteLib.new
      lib.delete if lib.exist?
      lib.create
      puts "path: #{lib.path}"
      puts "#{lib.count} quotes"
    end
  end
end
