# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "ocean_deploy_test"
set :repo_url, "git@github.com:Tranchinhthuc/ocean_deploy_test.git"

set :branch, ENV['BRANCH'] || "master"

set :use_sudo, true
set :bundle_binstubs, nil
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:reload'
  end
end
