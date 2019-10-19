module Makoto
  class Mastodon < Ginseng::Mastodon
    include Package

    def initialize(uri = nil, token = nil)
      super(uri, token)
      @config = Config.instance
    end

    def followers(params = {})
      headers = params[:headers] || {}
      headers['Authorization'] ||= "Bearer #{@token}"
      headers['X-Mulukhiya'] = package_class.full_name unless mulukhiya_enable?
      id = params[:id] || @config['/mastodon/account/id']
      return @http.get(create_uri("/api/v1/accounts/#{id}/followers"), {
        body: '{}',
        headers: headers,
        limit: @config['/mastodon/account/limit'],
      })
    end

    def followees(params = {})
      headers = params[:headers] || {}
      headers['Authorization'] ||= "Bearer #{@token}"
      headers['X-Mulukhiya'] = package_class.full_name unless mulukhiya_enable?
      id = params[:id] || @config['/mastodon/account/id']
      return @http.get(create_uri("/api/v1/accounts/#{id}/following"), {
        body: '{}',
        headers: headers,
        limit: @config['/mastodon/account/limit'],
      })
    end
  end
end
