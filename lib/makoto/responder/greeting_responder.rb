module Makoto
  class GreetingResponder < Responder
    def executable?
      return @params['content'].match(/おはよう|こんにち[はわ]|こんばん[はわ]/)
    end

    def exec
      return @matches[0]
    end
  end
end
