module Makoto
  class RandomTest < Test::Unit::TestCase
    def test_create
      assert_kind_of(Makoto::Random, Random.create)
    end
  end
end
