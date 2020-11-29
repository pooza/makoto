module Makoto
  class CallingResponder < Responder
    def executable?
      return rand < @config['/respond/calling/frequency']
    end

    def continue?
      return rand < @config['/respond/calling/continue']
    end

    def exec
      return Message.pickup(type: 'calling').message % [display_name]
    end
  end
end
