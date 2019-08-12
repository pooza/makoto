require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'
require 'ginseng'

module Makoto
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Environment
  autoload :Logger
  autoload :Package
  autoload :Slack
end
