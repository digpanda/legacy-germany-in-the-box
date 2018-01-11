namespace :cron do
  desc 'Check the validity of all the links added by the admins, change their status and possibly notify the admins about it'
  task check_links_validity: :environment do
    Tasks::Cron::CheckLinksValidity.new.perform
  end
  desc 'Remove all the empty carts from the database'
  task remove_empty_carts: :environment do
    Tasks::Cron::RemoveEmptyCarts.new.perform
  end
  desc 'Refresh all the on-going order tracking status from the API'
  task refresh_trackings: :environment do
    Tasks::Cron::RefreshTrackings.new.perform
  end
end
