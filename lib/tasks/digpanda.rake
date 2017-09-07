namespace :digpanda do
  desc 'check database consistency'
  task check_database_consistency: :environment do
    Tasks::Digpanda::CheckDatabaseConsistency.new
  end

  desc 'reset user registrations from KeenIO'
  task keen_reset_registrations: :environment do
    Tasks::Digpanda::KeenResetRegistrations.new
  end

  desc 'refresh duty categories taxes'
  task refresh_duty_categories_taxes: :environment do
    Tasks::Digpanda::RefreshDutyCategoriesTaxes.new
  end

  desc 'refresh shipping rates'
  task refresh_shipping_rates: :environment do
    Tasks::Digpanda::RefreshShippingRates.new
  end

  desc 'remove and create duty categories'
  task remove_and_create_duty_categories: :environment do
    Tasks::Digpanda::RemoveAndCreateDutyCategories.new
  end

  desc 'remove and create ui categories data'
  task remove_and_create_ui_categories: :environment do
    Tasks::Digpanda::RemoveAndCreateUiCategories.new
  end

  desc 'remove and create complete sample data'
  task remove_and_create_complete_sample_data: :environment do
    Tasks::Digpanda::RemoveAndCreateCompleteSampleData.new.perform
  end

  desc 'reset all the bill ids'
  task reset_bill_ids: :environment do
    Tasks::Digpanda::ResetBillIds.new
  end
end
