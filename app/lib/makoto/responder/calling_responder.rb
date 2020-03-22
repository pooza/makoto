module Makoto
  class CallingResponder < Responder
    def executable?
      return rand(0..99) < 80
    end

    def exec
      return Message.pickup(type: 'calling').message % [display_name]
    end
  end
end
