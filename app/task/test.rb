desc 'test all'
task :test do
  require 'timecop'
  require 'pp'
  Makoto::TestCase.load
end
