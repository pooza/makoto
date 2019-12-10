namespace :makoto do
  namespace :word do
    desc 'update words'
    task :update do
      dic = Makoto::Dictionary.new
      dic.refresh
      puts "#{dic.count} words"
      dic.install
      puts "Install: #{dic.path}"
    end
  end
end
