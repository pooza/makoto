desc 'test all'
task :test do
  ENV['TEST'] = Makoto::Package.name
  require 'test/unit'
  Dir.glob(File.join(Makoto::Environment.dir, 'test/*.rb')).each do |t|
    require t
  end
end
