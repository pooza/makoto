module Makoto
  class PastKeyword < Sequel::Model(:past_keyword)
    many_to_one :account

    def self.purge
      Postgres.instance.connection.transaction do
        keywords = PastKeyword.dataset
        keywords = keywords.where {created_at < 5.minutes.ago}
        keywords.destroy
      end
    end
  end
end
