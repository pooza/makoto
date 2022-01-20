module Makoto
  class Account < Sequel::Model(:account)
    one_to_many :past_keyword

    def fav!(value)
      return unless value
      update(favorability: (favorability || 0) + value)
    end

    def friendry?
      return 30 <= favorability
    end

    def dislike?
      return favorability <= -30
    end

    def hate?
      return favorability <= -60
    end

    def self.get(acct)
      return Account.first(acct:) || Account.create(acct:)
    end
  end
end
