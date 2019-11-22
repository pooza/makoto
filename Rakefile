dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'makoto'

[:start, :stop, :restart].each do |action|
  desc "#{action} all"
  task action => [
    "makoto:listener:#{action}",
    "makoto:thin:#{action}",
    "makoto:sidekiq:#{action}",
  ]
end

Dir.glob(File.join(Makoto::Environment.dir, 'app/task/*.rb')).each do |f|
  require f
end
