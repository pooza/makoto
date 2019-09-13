module Makoto
  class DentalResponder < Responder
    def executable?
      return @params['content'].match(
        /(歯医者|虫歯|歯みがき|歯磨き|抜歯|歯槽膿漏|知覚過敏|歯周病)/,
      )
    end

    def exec
      return quotes(keyword: '歯').sample
    end
  end
end
