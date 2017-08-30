namespace :cron do
  desc "Check the validity of all the links added by the admins, change their status and possibly notify the admins about it"
  task check_links_validity: :environment do
    Tasks::Cron::CheckLinksValidity.new.perform
  end
end
