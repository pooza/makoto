module Makoto
  class PrincessResponder < Responder
    def executable?
      return @params['content'].match(/王女(様|さま)/)
    end

    def exec
      return quotes(form: ['剣崎真琴', 'キュアソード'], keyword: '王女様').sample
    end
  end
end
