module Makoto
  class DentalResponder < Responder
    def exec
      return quotes(keyword: '歯').sample
    end
  end
end
