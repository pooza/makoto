module Makoto
  class NewYearMonologueWorker < Worker
    def perform
      template = Template.new('new_year')
      template[:greeting] = @config['/new_year/greeting']
      mastodon.toot(status: template.to_s, visibility: visibility)
    end
  end
end
