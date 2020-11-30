module Makoto
  class SongResponderTest < TestCase
    def setup
      @responder = SongResponder.new
    end

    def test_executable?
      @responder.params = {'content' => '歌って！'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '「こころをこめて」を歌って！'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end

    def test_continue?
      assert_false(@responder.continue?)
    end

    def test_exec
      assert_kind_of(Array, @responder.exec)
    end
  end
end
