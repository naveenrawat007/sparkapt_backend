require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
# require 'mina_sidekiq/tasks'

set :application_name, 'smartapt'
set :domain, '192.53.163.52'
set :deploy_to, '/sites/smartapt-backend'
set :repository, 'git@github.com:complitech/SmartApt-Backend.git'
set :branch, 'master'
set :rails_env, 'production'
set :keep_releases, 5
set :user, 'root'
# set :port, '19070'
set :restart_command, '/etc/init.d/smartapt-backend restart'
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'tmp/log', 'storage')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/unicorn.rb', 'config/secrets.yml', 'config/storage.yml', 'config/sidekiq.yml', 'config/environments/production.rb', 'config/cable.yml', 'config/credentials.yml.enc')

task :remote_environment do
  invoke :'rbenv:load'
end

task :setup do
  # command %(mkdir -p "#{fetch(:deploy_to)}/shared/pids/")
  # command %(mkdir -p "#{fetch(:deploy_to)}/shared/log/")
  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[touch "#{fetch(:shared_path)}/config/unicorn.rb"]
  command %[touch "#{fetch(:shared_path)}/config/secrets.yml"]
  command %[touch "#{fetch(:shared_path)}/config/storage.yml"]
  command %[touch "#{fetch(:shared_path)}/config/sidekiq.yml"]
  command %[touch "#{fetch(:shared_path)}/config/environments/production.rb"]
  command %[touch "#{fetch(:shared_path)}/config/cable.yml"]
  command %[touch "#{fetch(:shared_path)}/config/credentials.yml.enc"]
  command %[touch "#{fetch(:shared_path)}/log/production.log"]
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    # invoke :'sidekiq:quiet'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    #invoke :'rails:db_create'
    invoke :'rails:db_migrate'
    #invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'restart'
    on :launch do
      # invoke :'sidekiq:restart'
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end
end

task :restart do
  command "#{fetch(:restart_command)}"
end

task :accesslog do
  command "tail -f #{fetch(:deploy_to)}/current/log/production.log"
end
