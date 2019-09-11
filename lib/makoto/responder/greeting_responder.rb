module Makoto
  class GreetingResponder < Responder
    def executable?
      @matches = @params['content'].match(/おはよう|こんにち[はわ]|こんばん[はわ]/)
      return @matches.present?
    end

    def exec
      return @matches[0]
    end
  end
end
