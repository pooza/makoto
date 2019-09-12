module Makoto
  class PrincessResponder < Responder
    def executable?
      return @params['content'].match(/王女(様|さま)/)
    end

    def exec
      return '王女様！'
    end
  end
end
