namespace :makoto do
  namespace :listener do
    [:start, :stop].each do |action|
      desc "#{action} #{ns}"
      task action do
        sh "#{File.join(Makoto::Environment.dir, 'bin/listener.rb')} #{action}"
      rescue => e
        warn "#{e.class} #{ns}:#{action} #{e.message}"
      end
    end

    desc "restart #{ns}"
    task restart: [:stop, :start]
  end
end
