desc 'test all'
task :test do
  Makoto::TestCase.load((ARGV.first&.split(/[^[:word:],]+/) || [])[1])
end
