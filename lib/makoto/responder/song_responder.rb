module Makoto
  class SongResponder < Responder
    def executable?
      @matches = @params['content'].match(/(.*)を(歌|うた)って/)
      return @matches.present?
    end

    def exec
      return "#{@matches[1]}を歌うわ。"
    end
  end
end
