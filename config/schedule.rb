# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "/var/www/germany_in_the_box/current/log/borderguru_cron.log"

# We are currently in UTC time

# 9:15am Germany
every :day, :at => '10:15am' do
  command 'The system has launched the rake task `cron:compile_and_transfer_orders_csvs_to_borderguru`'
  rake "cron:compile_and_transfer_orders_csvs_to_borderguru"
end

# 1:15pm Germany
every :day, :at => '1:15pm' do
  command 'The system has launched the rake task `cron:transmit_pickup_orders_to_hermes`'
  rake "cron:transmit_pickup_orders_to_hermes"
end

every :hour do
  command 'The system has launched the rake task `cron:get_missing_shippings_from_border_guru`'
  rake "cron:get_missing_shippings_from_border_guru"
end

# other cron jobs
# - reindexing entries for index
every :day do
  command 'The system has launched the rake task `rake mongoid_search:index`'
  rake "mongoid_search:index"
end

=begin
every 1.day, :at => '4:30 am' do
  runner "MyModel.task_to_run_at_four_thirty_in_the_morning"
end

every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner "SomeModel.ladeeda"
end

every :sunday, :at => '12pm' do # Use any day of the week or :weekend, :weekday
  runner "Task.do_something_great"
end

every '0 0 27-31 * *' do
  command "echo 'you can use raw cron syntax too'"
end

# run this task only on servers with the :app role in Capistrano
# see Capistrano roles section below
every :day, :at => '12:20am', :roles => [:app] do
  rake "app_server:task"
end

=end
