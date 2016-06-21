namespace :digpanda do

  desc "check database consistency"
  task check_database_consistency: :environment do
    load './lib/tasks/digpanda/check_database_consistency.rb'
    CheckDatabaseConsistency.new
  end

  desc "remove and create duty categories"
  task remove_and_create_duty_categories: :environment do
    load './lib/tasks/digpanda/remove_and_create_duty_categories.rb'
    RemoveAndCreateDutyCategories.new
  end

  desc "remove and create ui categories data"
  task remove_and_create_ui_categories: :environment do
    load './lib/tasks/digpanda/remove_and_create_ui_categories.rb'
    RemoveAndCreateUiCategories.new
  end

  desc 'remove and create complete sample data'
  task remove_and_create_complete_sample_data: :environment do
    load './lib/tasks/digpanda/remove_and_create_complete_sample_data.rb'
    RemoveAndCreateCompleteSampleData.new
  end

end
