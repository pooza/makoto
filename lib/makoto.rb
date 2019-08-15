require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'
require 'ginseng'
require 'sidekiq'
require 'sidekiq-scheduler'
require 'json'
require 'yaml'

module Makoto
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Environment
  autoload :Listener
  autoload :Logger
  autoload :Mastodon
  autoload :Package
  autoload :Slack
  autoload :Template

  autoload_under 'daemon' do
    autoload :ListenerDaemon
  end

  autoload_under 'worker' do
    autoload :TootWorker
  end
end
