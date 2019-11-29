module Makoto
  class Random < ::Random
    def self.create
      return Random.new(Time.now.to_i)
    end
  end
end
