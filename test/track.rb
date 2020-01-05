module Makoto
  class TrackTest < Test::Unit::TestCase
    def test_pickup
      track = Track.pickup
      assert_kind_of(Track, track)
      assert_kind_of(String, track.title)
      assert(track.title.present?)
    end
  end
end
