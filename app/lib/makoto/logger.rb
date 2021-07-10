module Makoto
  class Logger < Ginseng::Logger
    include Package

    def create_message(src)
      src = {bot: Environment.bot_name}.merge(src)
      return super
    end
  end
end
