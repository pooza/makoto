require 'timecop'
require 'pp'

desc 'test all'
task :test do
  Makoto::TestCase.load
end
