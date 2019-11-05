module Makoto
  class FixedResponder < Responder
    def executable?
      return true
    end

    def exec
      return @quotes.pickup(respond: true)
    end
  end
end
