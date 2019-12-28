require 'securerandom'

module Makoto
  class Random < ::Random
    def self.create
      return Random.new(SecureRandom.hex(16).to_i(16))
    end
  end
end
