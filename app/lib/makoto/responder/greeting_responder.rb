module Makoto
  class GreetingResponder < Responder
    def executable?
      config['/respond/greeting'].each do |v|
        raise MatchingError, 'no match greeting patterns' if !mention? && ignore?(v)
        next if v['pattern_rough'] && past_keywords.member?(v['pattern_rough'])
        next unless analyzer.match?(create_pattern(v['pattern']))
        @matches = v.key_flatten
        return true
      end
      return false
    end

    def favorability
      return nil unless @matches
      return rand(1..(@matches['/fav'] || 1))
    end

    def exec
      return nil unless executable?
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
      greetings.push(message.join)
    end

    def continue?
      return executable? && (@matches['/continue'] == true)
    end

    def on_time?
      return false unless executable?
      return false unless @matches['/hours'].nil? || @matches['/hours'].member?(hour)
      return false unless @matches['/dates'].nil? || @matches['/dates'].member?(date)
      return true
    end

    def quote_suffixes
      suffixes = Fairy.suffixes.clone
      suffixes.concat(RubicureAPIService.instance.quote_suffixes)
      return suffixes.uniq.compact
    end

    private

    def create_pattern(source)
      return Regexp.new("#{source}[でだ]?(#{quote_suffixes.join('|')})?([〜～~ー、。!?w]|\s|$)")
    end

    def ignore?(entry)
      return false unless entry['pattern_rough']
      return true if past_keywords.member?(entry['pattern_rough'])
      return false unless analyzer.match?(entry['pattern_rough'])
      return false if analyzer.match?(create_pattern(entry['pattern']))
      return true
    end

    def past_keywords
      return account.past_keyword.map(&:surface)
    end

    def hour
      return Time.now.hour
    end

    def date
      return Time.now.strftime('%m%d')
    end
  end
end
