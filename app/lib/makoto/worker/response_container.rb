module Makoto
  class ResponseContainer
    include Package
    attr_reader :greetings, :paragraphs

    def initialize
      clear
    end

    def clear
      @greetings = []
      @paragraphs = []
    end

    def to_s
      return [
        greetings.join,
        paragraphs.sample(rand(min..max)).join,
      ].select(&:present?).join("\n")
    end

    def max
      return config['/respond/paragraph/max']
    end

    def min
      return config['/respond/paragraph/min']
    end
  end
end
