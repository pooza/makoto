module Makoto
  class TrackTest < TestCase
    def test_pickup
      track = Track.pickup

      assert_kind_of(Track, track)
      assert_kind_of(String, track.title)
      assert_predicate(track.title, :present?)
    end
  end
end
