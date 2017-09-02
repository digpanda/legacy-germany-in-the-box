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
set :output, "/var/www/germany_in_the_box/current/log/cron.log"
#
# # We are currently in UTC time
# every :hour do
#   command 'The system has launched the rake task `cron:cron_name`'
#   rake "cron:cron_name"
# end

# other cron jobs
# - reindexing entries for index
every :hour do
  command 'The system has launched the rake task `rake mongoid_search:index`'
  rake "mongoid_search:index"
end

# - check all the links added to the admin dashboard and notify problems
every :day do
  command 'The system has launched the rake task `rake cron:check_links_validity`'
  rake "cron:check_links_validity"
end

# - reindexing models for slug ids
every :week do
  command 'The system has launched the rake task `rake mongoid_slug:set`'
  rake "mongoid_slug:set"
end
