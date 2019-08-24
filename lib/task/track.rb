namespace :makoto do
  namespace :track do
    desc 'update tracks'
    task :update do
      lib = Makoto::TrackLib.new
      lib.delete if lib.exist?
      lib.create
      puts "path: #{lib.path}"
      puts "#{lib.count} tracks"
    end
  end
end
