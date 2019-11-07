module Makoto
  class RandomTest < Test::Unit::TestCase
    def test_create
      assert(Random.create.is_a?(Makoto::Random))
    end
  end
end
