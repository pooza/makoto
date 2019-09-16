module Makoto
  class PrincessResponder < Responder
    def exec
      return quotes(form: ['剣崎真琴', 'キュアソード'], keyword: '王女様').sample
    end
  end
end
