require 'rubicure'

module Makoto
  class PrecureBirthdayMonologueWorker < Worker
    def perform
      girls = Precure.all.select(&:birthday?)
      return if girls.empty?
      template = Template.new('precure_birthday')
      template[:girls] = girls
      mastodon.toot(status: template.to_s, visibility: visibility)
    end
  end
end
