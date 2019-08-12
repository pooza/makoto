dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'makoto'

Dir.glob(File.join(Makoto::Environment.dir, 'lib/task/*.rb')).each do |f|
  require f
end
