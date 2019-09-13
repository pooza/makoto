module Makoto
  class DentalResponder < Responder
    def executable?
      return @params['content'].match(/(歯医者|虫歯|歯みがき|歯磨き|抜歯)/)
    end

    def exec
      return quotes(keyword: '歯').sample
    end
  end
end
