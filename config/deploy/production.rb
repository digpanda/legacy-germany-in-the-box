role :app, %w{digpanda@germanyinthebox.com}
role :web, %w{digpanda@germanyinthebox.com}
role :db,  %w{digpanda@germanyinthebox.com}

set :rvm_ruby_version, '2.3.0'
set :rvm_type, :user
set :rvm_custom_path, '/usr/share/rvm'

set :ssh_options, {
  keys: %w(../private/production/digpanda-prod.pem),
  forward_agent: true,
  auth_methods: %w(publickey, password)
}

set :branch, ENV['BRANCH'] || :production