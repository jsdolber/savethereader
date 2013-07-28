set :application, "savethereader"
set :deploy_to, "/var/www/#{application}"
set :repository,  "git@github.com:jsdolber/savethereader.git"
set :port, 30003
set :user, 'oneman'
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#set :scm_user, "jsdolber"
#
set :rvm_type, :system
set :rvm_install_with_sudo, true


server "ks4000727.ip-198-245-63.net", :app, :web, :primary => true
#role :db,  "sugarglider.c5vxgq82kuz5.us-west-2.rds.amazonaws.com", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"
require 'capistrano-unicorn'
after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded
