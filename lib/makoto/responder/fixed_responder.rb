module Makoto
  class FixedResponder < Responder
    def executable?
      return true
    end

    def exec
      return @quote_lib.quotes.sample
    end
  end
end
