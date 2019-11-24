module Makoto
  class BadMoodResponder < Responder
    def executable?
      return true if account.hate?
      @config['/respond/bad_mood/words'].each do |word|
        return true if @params['content'].include?(word)
      end
      return false
    end

    def favorability
      return rand(1..5) * -1
    end

    def exec
      return Quote.pickup(emotion: :bad).body + '🤨'
    end
  end
end
