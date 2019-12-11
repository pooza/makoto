namespace :makoto do
  namespace :dic do
    desc 'update dictionary'
    task :update do
      dic = Makoto::Dictionary.new
      dic.refresh
      puts "fetch: #{dic.count} words"
      dic.install
      puts "install: #{dic.user_dic_path}"
    end
  end
end
