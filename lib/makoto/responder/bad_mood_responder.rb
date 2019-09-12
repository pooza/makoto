module Makoto
  class BadMoodResponder < Responder
    def executable?
      @config['/word/ng'].each do |word|
        return true if @params['content'].include?(word)
      end
      return false
    end

    def exec
      return quotes(emotion: :bad).sample + '🤨'
    end
  end
end
