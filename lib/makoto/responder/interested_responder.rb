module Makoto
  class InterestedResponder < Responder
    def executable?
      @config['/respond/interested'].each do |entry|
        entry['words'] ||= [entry['quote']]
        entry['words'].each do |word|
          next unless @params['content'].include?(word)
          @keyword = entry['quote']
          return true
        end
      end
      return false
    end

    def exec
      return quotes(form: ['剣崎真琴', 'キュアソード'], keyword: @keyword).sample
    end
  end
end
