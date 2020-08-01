namespace :makoto do
  namespace :dic do
    [:local, :neologd].each do |key|
      namespace key do
        desc "update #{key} dictionary"
        task :update do
          dic = "Makoto::#{key.to_s.classify}Dictionary".constantize.new
          dic.refresh
          puts "words: #{dic.count.commaize}"
          dic.install
          puts "path: #{dic.path}"
        end
      end
    end
  end
end
