module Makoto
  class BadMoodResponder < Responder
    def executable?
      return true if account.hate?
      words = analyze.map {|v| v[:surface]}
      @config['/respond/bad_mood/words'].each do |word|
        return true if words.member?(word)
      end
      return false
    end

    def favorability
      return rand(1..5) * -1
    end

    def exec
      return Quote.pickup(emotion: :bad, respond: true).body + '🤨'
    end
  end
end
