module Makoto
  class RandomTest < TestCase
    def test_create
      assert_kind_of(Makoto::Random, Random.create)
    end
  end
end
