namespace :dev do

  desc "Rebuild system"
  task :build => ["tmp:clear","db:drop", "db:create", "db:migrate", :setup]
  
  desc "Setup system data"
  task :setup => :environment do

      puts "Create system user"
      u = User.new( :login => "xdite", :password => "openid", :password_confirmation => "openid", :email => "root@openid.com" )
      u.save!
  end

end
