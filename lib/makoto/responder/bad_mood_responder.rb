module Makoto
  class BadMoodResponder < Responder
    def exec
      return Quote.pickup(emotion: :bad).body + '🤨'
    end
  end
end
