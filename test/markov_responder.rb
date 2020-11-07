module Makoto
  class MarkovResponderTest < TestCase
    def setup
      @responder = MarkovResponder.new
    end

    def test_executable?
      assert_boolean(@responder.executable?)
    end

    def test_table
      @responder.table.each do |entry|
        assert_kind_of(Array, entry)
        assert_equal(entry.length, 2)
        assert_equal(entry.first.length, 2)
      end
    end

    def test_markov
      puts @responder.markov
      assert(@responder.markov.present?)
    end
  end
end
