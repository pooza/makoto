namespace :makoto do
  [:listener, :sidekiq, :puma].each do |ns|
    namespace ns do
      [:start, :stop].freeze.each do |action|
        desc "#{action} #{ns}"
        task action do
          sh "#{File.join(Makoto::Environment.dir, 'bin', "#{ns}_daemon.rb")} #{action}"
        rescue => e
          warn "#{e.class} #{ns}:#{action} #{e.message}"
        end
      end

      desc "restart #{ns}"
      task restart: [:stop, :start]
    end
  end
end

[:start, :stop, :restart].each do |action|
  desc "#{action} all"
  multitask action => [
    "makoto:listener:#{action}",
    "makoto:puma:#{action}",
    "makoto:sidekiq:#{action}",
  ]
end
