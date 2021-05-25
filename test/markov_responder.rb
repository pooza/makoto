module Makoto
  class MarkovResponderTest < TestCase
    def setup
      @responder = MarkovResponder.new
    end

    def test_executable?
      assert_boolean(@responder.executable?)
    end

    def test_continue?
      assert_boolean(@responder.continue?)
    end

    def test_table
      @responder.table.first(100).each do |entry|
        assert_kind_of(Array, entry)
        assert_equal(entry.length, 2)
        assert_equal(entry.first.length, 2)
      end
    end

    def test_markov
      assert(@responder.markov.present?)
    end

    def test_exec
      @responder.exec
      assert(@responder.paragraphs.present?)
    end
  end
end
