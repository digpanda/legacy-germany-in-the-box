namespace :redis do
  desc 'Install Redis server'
  task :install do
    queue %{echo '-----> Installing Redis...'}
    queue 'sudo apt-get update -y'
    queue 'sudo apt-get install redis-server -y'
    queue 'sudo apt-get clean -y'
  end

  %w[Start Stop Restart Status].each do |command|
    desc "#{command} Redis"
    task command.downcase do
      queue %{echo "-----> Trying to #{command.downcase} Redis..."}
      queue "sudo service redis-server #{command.downcase}"
    end
  end
end
