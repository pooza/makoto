module Makoto
  class ResponseContainerTest < TestCase
    def setup
      @container = ResponseContainer.new
    end

    def test_paragraphs
      assert_kind_of(Array, @container.paragraphs)
    end

    def test_greetings
      assert_kind_of(Array, @container.greetings)
    end

    def test_clear
      @container.greetings.push('こんにちは。')
      @container.paragraphs.push('天ぷらそば')
      @container.paragraphs.push('ネギトロ丼')

      assert_false(@container.greetings.empty?)
      assert_false(@container.paragraphs.empty?)
      @container.clear

      assert_empty(@container.greetings)
      assert_empty(@container.paragraphs)
    end

    def test_to_s
      @container.clear
      @container.greetings.push('こんにちは。')
      @container.paragraphs.push('天ぷらそば')
      @container.paragraphs.push('ネギトロ丼')

      assert_match(/^こんにちは。\n(天ぷらそば|ネギトロ丼)+$/, @container.to_s)
    end
  end
end
