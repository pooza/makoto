module Makoto
  class Account < Sequel::Model(:account)
    def fav!(v)
      return unless v
      update(favorability: (self.favorability || 0) + v)
    end

    def self.get(acct)
      unless account = Account.first(acct: acct)
        account = Account.create(acct: acct)
      end
      return account
    end
  end
end
