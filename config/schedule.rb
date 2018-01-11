# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, '/path/to/my/cron_log.log'
#
# every 2.hours do
#   command '/usr/bin/some_great_command'
#   runner 'MyModel.some_method'
#   rake 'some:great:rake:task'
# end
#
# every 4.days do
#   runner 'AnotherModel.prune_old_records'
# end

# Learn more: http://github.com/javan/whenever
set :output, '/var/www/germany_in_the_box/current/log/cron.log'
#
# # We are currently in UTC time
# every :hour do
#   command 'The system has launched the rake task `cron:cron_name`'
#   rake 'cron:cron_name'
# end


# NOTE : this rake task has been removed because the u_at was updated systematically
# and I realized the search system was automatically updated on adding new entries. - Laurent
# - reindexing entries for index
# every :hour do
#   command 'The system has launched the rake task `rake mongoid_search:index`'
#   rake 'mongoid_search:index'
# end
#

# - refresh all the on going order trackings from the API
every :day do
  command 'The system has launched the rake task `rake cron:refresh_trackings`'
  rake 'cron:refresh_trackings'
end

# - check all the links added to the admin dashboard and notify problems
every :day do
  command 'The system has launched the rake task `rake cron:check_links_validity`'
  rake 'cron:check_links_validity'
end

# - remove all the empty carts from the database
every :day do
  command 'The system has launched the rake task `rake cron:remove_empty_carts`'
  rake 'cron:remove_empty_carts'
end

# NOTE : the slug system update by itself now, so i cancelled this task. - Laurent
# - reindexing models for slug ids
# every :week do
#   command 'The system has launched the rake task `rake mongoid_slug:set`'
#   rake 'mongoid_slug:set'
# end
