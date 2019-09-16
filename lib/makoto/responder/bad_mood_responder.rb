module Makoto
  class BadMoodResponder < Responder
    def exec
      return quotes(emotion: :bad).sample + '🤨'
    end
  end
end
