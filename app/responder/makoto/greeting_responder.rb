module Makoto
  class GreetingResponder < Responder
    def executable?
      @config['/respond/greeting'].each do |v|
        next unless @params['content'].match(Regexp.new(v['pattern']))
        @matches = Config.flatten('', v)
        @matches['/hours'] ||= (0..23).to_a
        return true
      end
      return false
    end

    def fav
      return rand(1..(@matches['/fav'] || 1))
    end

    def exec
      message = []
      if @matches['/hours'].include?(Time.now.hour)
        message.push("#{display_name}、") unless account.dislike?
        if account.friendry?
          message.push(@matches['/response/friendry'] || @matches['/response/normal'])
          message.push(['！', '。'].sample)
        else
          message.push(@matches['/response/normal'])
          message.push('。')
        end
      else
        message.push(@matches['/response/ignore'] || @matches['/response/normal'])
        message.push(['？？', 'って…。', '？'].sample)
        message.push('😅') if account.friendry?
      end
      return message.join
    end

    def display_name
      name = @params['account']['display_name'].sub(/:$/, ': ')
      name += 'さん' unless account.friendry?
      return name
    end
  end
end
