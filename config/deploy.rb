set :application, "save_the_reader"
set :deploy_to, "/opt/#{application}"
set :repository,  "https://github.com/jsdolber/savethereader.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :scm_user, "jsdolber"

server "106.187.88.126", :app, :web, :primary => true
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
set :keep_releases, 5
after 'deploy:update_code', 'deploy:migrate'
after "deploy:restart", "deploy:cleanup" 
