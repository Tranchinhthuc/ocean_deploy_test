set :port, 22
set :user, 'tranthuc'
set :deploy_via, :remote_cache
set :use_sudo, false

server '174.138.26.120',
  roles: [:web, :app, :db],
  port: fetch(:port),
  user: fetch(:user),
  primary: true

set :deploy_to, "/home/tranthuc/apps/#{fetch(:application)}"

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  user: 'tranthuc',
}

set :rails_env, :production
set :conditionally_migrate, true
