module Makoto
  class PrincessResponder < Responder
    def executable?
      @config['/respond/princess/words'].each do |word|
        return true if @params['content'].include?(word)
      end
      return false
    end

    def exec
      return quotes(form: ['剣崎真琴', 'キュアソード'], keyword: '王女様').sample
    end
  end
end
