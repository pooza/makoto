require 'sanitize'

module Makoto
  class RepeatRespondWorker
    include Sidekiq::Worker

    def initialize
      @logger = Logger.new
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'])
      @mastodon.token = @config['/mastodon/token']
    end

    def perform(params)
      template = Template.new('toot')
      template[:account] = params['account']
      template[:message] = Sanitize.clean(params['content']).gsub(/@[[:word:]]+/, '')
      @mastodon.toot(status: template.to_s, visibility: params['visibility'])
    end
  end
end
