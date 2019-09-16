module Makoto
  class DentalResponder < Responder
    def executable?
      @config['/respond/dental/words'].each do |word|
        return true if @params['content'].include?(word)
      end
      return false
    end

    def exec
      return quotes(keyword: '歯').sample
    end
  end
end
