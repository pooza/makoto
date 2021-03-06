module Makoto
  class Server < Ginseng::Web::Sinatra
    include Package
    set :root, Environment.dir

    get '/makoto/health' do
      @renderer.message = Environment.health
      @renderer.status = @renderer.message[:status] || 200
      return @renderer.to_s
    end
  end
end
