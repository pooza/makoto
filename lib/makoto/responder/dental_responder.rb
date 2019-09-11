module Makoto
  class DentalResponder < Responder
    def executable?
      return @params['content'].match(/歯医者/)
    end

    def exec
      return '歯医者こわいの！'
    end
  end
end
