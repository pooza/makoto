require 'eventmachine'
require 'faye/websocket'

module Makoto
  class Listener
    include Package
    attr_reader :client, :uri, :mastodon

    private

    def initialize
      @mastodon = Mastodon.new(config['/mastodon/url'], config['/mastodon/token'])
      @uri = @mastodon.streaming_uri
      @client = Faye::WebSocket::Client.new(@uri.to_s, nil, {
        ping: config['/websocket/keepalive'],
      })
    end
  end
end
