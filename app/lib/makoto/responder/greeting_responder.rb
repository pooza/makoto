module Makoto
  class GreetingResponder < Responder
    def executable?
      text = Responder.create_source_text(@params['content'])
      @config['/respond/greeting'].each do |v|
        check_ignore(v)
        next unless text.match?(create_pattern(v['pattern']))
        @matches = v.key_flatten
        return true
      end
      return false if @params['mention']
      raise Ginseng::NotFoundError, self.class.to_s
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

    def on_time?
      return false unless @matches['/hours'].nil? || @matches['/hours'].member?(hour)
      return false unless @matches['/dates'].nil? || @matches['/dates'].member?(date)
      return true
    end

    private

    def create_pattern(source)
      return Regexp.new("#{source}[でだ]?(#{suffixes.join('|')})?([〜、。!]|\s|$)")
    end

    def suffixes
      @suffixes ||= Fairy.all.map {|f| f.suffix}.compact
      return @suffixes
    end

    def check_ignore(entry)
      return unless entry['pattern_rough']
      return unless @params['content'].include?(entry['pattern_rough'])
      return if @params['content'].match?(create_pattern(entry['pattern']))
      raise Ginseng::NotFoundError, 'no match pattern'
    end

    def display_name
      name = account.nickname || @params['account']['display_name'].sub(/:$/, ': ')
      name += 'さん' unless account.friendry?
      return name
    end

    def hour
      return Time.now.hour
    end

    def date
      return Time.now.strftime('%m%d')
    end
  end
end
