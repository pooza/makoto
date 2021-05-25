module Makoto
  class CallingResponder < Responder
    def executable?
      return rand < @config['/respond/calling/frequency']
    end

    def continue?
      return true
    end

    def exec
      paragraphs.push(Message.pickup(type: 'calling').message % [display_name])
    end
  end
end
