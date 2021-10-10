require 'eventmachine'
require 'faye/websocket'

module Makoto
  class Listener
    include Package
    attr_reader :client, :uri, :mastodon

    def verify_peer?
      return config['/websocket/verify_peer']
    end

    def keepalive
      return config['/websocket/keepalive']
    end

    private

    def initialize
      @mastodon = Mastodon.new(config['/mastodon/url'], config['/mastodon/token'])
      @uri = @mastodon.streaming_uri
      @client = Faye::WebSocket::Client.new(@uri.to_s, nil, {
        tls: {
          verify_peer: verify_peer?,
        },
        ping: keepalive,
      })
    end
  end
end
