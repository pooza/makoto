module Makoto
  class GreetingResponder < Responder
    def executable?
      @config['/respond/greeting'].each do |v|
        next unless @params['content'].match(Regexp.new(v['pattern']))
        @matches = Config.flatten('', v)
        return true
      end
      return false
    end

    def exec
      message = [@matches['/response/body']]
      if @matches['/hours'].include?(Time.now.hour)
        message.push(['！', '。'].sample)
      else
        message.push(['？？', 'って…。😅', '？😅'].sample)
      end
      return message.join
    end
  end
end
