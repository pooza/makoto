module Makoto
  class FixedResponder < Responder
    def executable?
      return true
    end

    def exec
      return {
        paragraphs: [Quote.pickup(respond: true).body],
      }
    end
  end
end
