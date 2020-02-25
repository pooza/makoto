module Makoto
  class GreetingResponder < Responder
    def executable?
      @config['/respond/greeting'].each do |v|
        next unless @params['content'].match(Regexp.new(v['pattern']))
        @matches = v.key_flatten
        return true
      end
      return false
    end

    def favorability
      return rand(1..(@matches['/fav'] || 1))
    end

    def exec
      message = []
      if on_time?
        message.push("#{display_name}、") unless account.dislike?
        if account.friendry?
          message.push(@matches['/response/friendry'] || @matches['/response/normal'])
          message.push(['！', '。', '〜。'].sample)
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
      name = account.nickname || @params['account']['display_name'].sub(/:$/, ': ')
      name += 'さん' unless account.friendry?
      return name
    end

    def on_time?
      return false unless @matches['/hours'].nil? || @matches['/hours'].member?(hour)
      return false unless @matches['/dates'].nil? || @matches['/dates'].member?(date)
      return true
    end

    def hour
      return Time.now.hour
    end

    def date
      return Time.now.strftime('%m%d')
    end
  end
end
