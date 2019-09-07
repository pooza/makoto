require 'sanitize'
require 'unicode'

module Makoto
  class MessageBuilder
    def initialize(received)
      @received = received
    end

    def self.sanitize(message)
      message = Sanitize.clean(message)
      message = Unicode.nfkc(message)
      return message
    end

    def self.create_content(status)
      tags = []
      content = MessageBuilder.sanitize(status['content'])
      MessageBuilder.topics.each do |topic|
        tags.push(Mastodon.create_tag(topic)) if content.include?(topic)
      end
      return "#{content} #{tags.join(' ')}"
    end

    def self.respondable?(payload)
      return false if MessageBuilder.ignore_accounts.include?(payload['account']['acct'])
      content = MessageBuilder.sanitize(payload['content'])
      return false if content.match(Regexp.new("@#{MessageBuilder.bot_account}(\\s|$)"))
      MessageBuilder.topics.each do |topic|
        return true if content.include?(topic)
      end
      return false
    end

    def self.bot_account
      return Config.instance['/reply/me']
    end

    def self.ignore_accounts
      return Config.instance['/reply/ignore_accounts']
    end

    def self.topics
      return Config.instance['/reply/topics']
    end
  end
end
