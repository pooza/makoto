module Makoto
  class FixedResponder < Responder
    def executable?
      return true
    end

    def exec
      paragraphs.push(Quote.pickup(respond: true).body)
    end
  end
end
