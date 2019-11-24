module Makoto
  class Account < Sequel::Model(:account)
    def fav!(value)
      return unless value
      update(favorability: (favorability || 0) + value)
    end

    def friendry?
      return 50 < favorability
    end

    def dislike?
      return favorability < -50
    end

    def hate?
      return favorability < -100
    end

    def self.get(acct)
      unless account = Account.first(acct: acct)
        account = Account.create(acct: acct)
      end
      return account
    end
  end
end
