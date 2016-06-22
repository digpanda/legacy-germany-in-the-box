namespace :digpanda do

  desc "check database consistency"
  task check_database_consistency: :environment do
    Tasks::Digpanda::CheckDatabaseConsistency.new
  end

  desc "remove and create duty categories"
  task remove_and_create_duty_categories: :environment do
    Tasks::Digpanda::RemoveAndCreateDutyCategories.new
  end

  desc "remove and create ui categories data"
  task remove_and_create_ui_categories: :environment do
    Tasks::Digpanda::RemoveAndCreateUiCategories.new
  end

  desc 'remove and create complete sample data'
  task remove_and_create_complete_sample_data: :environment do
    Tasks::Digpanda::RemoveAndCreateCompleteSampleData.new
  end

end
