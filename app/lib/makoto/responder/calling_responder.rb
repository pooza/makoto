module Makoto
  class CallingResponder < Responder
    def executable?
      return rand < @config['/respond/calling/frequency']
    end

    def continue?
      return true
    end

    def exec
      return {
        paragraphs: [Message.pickup(type: 'calling').message % [display_name]],
      }
    end
  end
end
