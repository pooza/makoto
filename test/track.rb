module Makoto
  class TrackTest < Test::Unit::TestCase
    def setup
      @config = Config.instance
      @tracks = Track.new
    end

    def test_exist?
      assert(@tracks.exist?)
    end

    def test_path
      assert(@tracks.path.present?)
    end

    def test_pickup
      assert(@tracks.pickup.is_a?(String))
      assert(@tracks.pickup(detail: true).is_a?(Hash))
    end

    def test_tracks
      assert(@tracks.tracks.is_a?(Array))
      @tracks.tracks(detail: true)[0..10].each do |track|
        assert(track['title'].is_a?(String))
        assert(track['makoto'].blank? || track['makoto'].positive?)
        assert(track['url'].is_a?(String))
      end
    end

    def test_keep?
      entry = {
        'title' => '〜SONGBIRD〜',
        'makoto' => 1,
        'url' => 'https://open.spotify.com/track/5m0gVQm3UMJ2M8dyWHL76Q?si=AmBsr3PhR4iPUWEbVhu_mg',
      }
      assert(@tracks.keep?(entry, {}))

      assert_false(@tracks.keep?(entry, {title: 'hoge'}))
      assert(@tracks.keep?(entry, {title: 'SONGBIRD'}))

      assert(@tracks.keep?(entry, {makoto: 1}))
      entry['makoto'] = nil
      assert_false(@tracks.keep?(entry, {makoto: 1}))
    end
  end
end
