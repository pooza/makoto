module Makoto
  class SongResponderTest < Test::Unit::TestCase
    def setup
      @responder = SongResponder.new
    end

    def test_exec
      @responder.params = {'content' => '歌って！'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '「こころをこめて」を歌って！'}
      assert(@responder.executable?)
      assert(@responder.exec.present?) unless Environment.ci?
    end
  end
end
