module Makoto
  class TrackLibTest < Test::Unit::TestCase
    def setup
      @config = Config.instance
      @lib = TrackLib.new
      @lib.refresh
    end

    def test_exist?
      assert(@lib.exist?)
    end

    def test_path
      assert(@lib.path.present?)
    end

    def test_pickup
      assert(@lib.pickup.is_a?(String))
      assert(@lib.pickup(detail: true).is_a?(Hash))
    end

    def test_tracks
      assert(@lib.tracks.is_a?(Array))
      @lib.tracks(detail: true)[0..10].each do |track|
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
      assert(@lib.keep?(entry, {}))

      assert_false(@lib.keep?(entry, {title: 'hoge'}))
      assert(@lib.keep?(entry, {title: 'SONGBIRD'}))

      assert(@lib.keep?(entry, {makoto: 1}))
      entry['makoto'] = nil
      assert_false(@lib.keep?(entry, {makoto: 1}))
    end
  end
end
