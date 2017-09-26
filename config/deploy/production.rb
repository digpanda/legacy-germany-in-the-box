role :app, %w{digpanda@germanyinthebox.com}
role :web, %w{digpanda@germanyinthebox.com}
role :db,  %w{digpanda@germanyinthebox.com}

set :rvm_ruby_version, '2.3.0'
set :rvm_type, :user
set :rvm_custom_path, '/home/digpanda/.rvm'

set :nvm_node, 'v5.0.0'
set :nvm_type, :user
set :nvm_map_bins, %w{node npm}
# set :nvm_custom_path, '/home/digpanda/.nvm'

set :ssh_options,
  keys: %w(../private/production/digpanda-production.pem),
  forward_agent: true,
  auth_methods: %w(publickey, password)

set :branch, :master
