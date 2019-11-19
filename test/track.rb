module Makoto
  class TrackTest < Test::Unit::TestCase
    def test_pickup
      return if Environment.ci?
      track = Track.pickup
      assert(track.is_a?(Track))
      assert(track.title.is_a?(String))
      assert(track.title.present?)
    end
  end
end
