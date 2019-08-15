module Makoto
  class Mastodon < Ginseng::Mastodon
    def create_streaming_uri(stream = 'user')
      uri = self.uri.clone
      uri.scheme = 'wss'
      uri.path = '/api/v1/streaming'
      uri.query_values = {'access_token' => token, 'stream' => stream}
      return uri
    end
  end
end
