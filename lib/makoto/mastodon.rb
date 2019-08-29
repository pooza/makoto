module Makoto
  class Mastodon < Ginseng::Mastodon
    def follow(id, params = {})
      headers = params[:headers] || {}
      headers['Authorization'] ||= "Bearer #{@token}"
      headers['X-Mulukhiya'] = package_class.full_name unless mulukhiya_enable?
      return @http.post(create_uri("/api/v1/accounts/#{id}/follow"), {
        body: '{}',
        headers: headers,
      })
    end

    def create_streaming_uri(stream = 'user')
      uri = self.uri.clone
      uri.scheme = 'wss'
      uri.path = '/api/v1/streaming'
      uri.query_values = {'access_token' => token, 'stream' => stream}
      return uri
    end
  end
end
