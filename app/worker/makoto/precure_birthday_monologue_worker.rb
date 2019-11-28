require 'rubicure'

module Makoto
  class PrecureBirthdayMonologueWorker < Worker
    def perform
      girls = Precure.all.keep_if(&:birthday?)
      return unless girls.present?
      template = Template.new('precure_birthday')
      template[:girls] = girls
      mastodon.toot(template.to_s)
    end
  end
end
