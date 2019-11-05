module Makoto
  class BadMoodResponder < Responder
    def exec
      return @quotes.pickup(emotion: :bad) + '🤨'
    end
  end
end
