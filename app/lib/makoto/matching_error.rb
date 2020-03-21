module Makoto
  class MatchingError < Ginseng::NotFoundError
    include Package
  end
end
