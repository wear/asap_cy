
set :application, "asap"   
  
task :staging do
#  set :repository,  "http://svn.daorails.com/asap_cy/trunk"
  set :repository,  "http://asap.daorails.com/svn/cy" 
  set :scm_username, "stephen"
  set :scm_password, "zzzzzz"

  set :use_sudo, false
  set :user, "wear"    
  set :deploy_to, "/home/wear/www/#{application}"      
  set :mongrel_config, 'mongrel_cluster.staging.yml'
  server "221.130.199.91", :app, :web, :db, :primary => true
  set :stage, :staging
end

task :demo do
  set :repository,  "http://www.daorails.com/svn/cy"
  set :scm_username, "stephen"
  set :scm_password, "zzzzzz"
  set :use_sudo, false 
  set :user, "seazhang"    
  set :deploy_to, "/home/seazhang/deploy"      
  set :mongrel_config, 'mongrel_cluster.demo.yml'
  server "192.168.12.209", :app, :web, :db, :primary => true
  set :stage, :demo
end
   
namespace :mongrel do
  [ :stop, :start, :restart ].each do |t|
    desc "#{t.to_s.capitalize} the mongrel appserver"
    task t, :roles => :app do
      #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
      run "sudo mongrel_rails cluster::#{t.to_s} -C #{deploy_to}/current/config/#{mongrel_config}"
    end
  end
end  

namespace :preload do
  rails_env = fetch(:rails_env, 'production')
  rake = fetch(:rake, 'rake')     
#  rake = '/usr/local/ruby/bin/rake'
  
  desc "load bootstrap"
  task :bootstrap, :roles => :app do 
    run "cd #{current_path}; #{rake} db:bootstrap RAILS_ENV=#{rails_env}"
  end 

  desc "load comatose"
  task :comatose, :roles => :app do 
    run "cd #{current_path}; #{rake} comatose:data:import RAILS_ENV=#{rails_env}"
  end
  
  desc "drop old db"
  task :dropdb, :roles => :app do 
    run "cd #{current_path}; #{rake} db:drop RAILS_ENV=#{rails_env}"
  end
  
  desc "create new db"
  task :createdb, :roles => :app do 
    run "cd #{current_path}; #{rake} db:create RAILS_ENV=#{rails_env}"
  end
  
  desc "migrate the db"
  task :migrate, :roles => :app do 
    run "cd #{current_path}; #{rake} db:migrate RAILS_ENV=#{rails_env}"
  end
  
  desc "set vendor sumary score"
  task :set_score, :roles => :app do 
    run "cd #{current_path}; #{rake} db:vendor_initial RAILS_ENV=#{rails_env}"
  end
end

namespace :deploy do
  
  desc "Long deploy will update the code migrate the database and restart the servers"
  task :long do
    transaction do
      update
      copy_configs
      preload.dropdb 
      preload.createdb 
      preload.migrate
      preload.bootstrap
      preload.comatose
      preload.set_score
    end
    
    restart
  end
  
  desc "don recreate the database"
  task :short do
   transaction do  
     update
     copy_configs
   end
   
    restart 
  end         
  
  
  desc "Custom after update code to put production database.yml in place."
  task :copy_configs, :roles => :app do
   # run "ln -s #{deploy_to}/shared/users #{deploy_to}/current/public/users"
    run "cp #{deploy_to}/current/config/database.yml.#{stage} #{deploy_to}/current/config/database.yml" 
    run "cp #{deploy_to}/current/app/views/vendors/map.html.erb.#{stage} #{deploy_to}/current/app/views/vendors/map.html.erb" 
  end
  
  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    mongrel.restart
  end

  desc "Custom start task for mongrel cluster"
  task :start, :roles => :app do
    mongrel.start
  end

  desc "Custom stop task for mongrel cluster"
  task :stop, :roles => :app do
    mongrel.stop
  end  
  
end  
