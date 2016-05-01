namespace :achat do

  desc "create duty categories data"
  task remove_and_create_duty_categories: :environment do
    load './lib/tasks/categories/duty.rb'
  end

  desc "create ui categories data"
  task remove_and_create_ui_categories: :environment do
    load './lib/tasks/categories/ui.rb'
  end

  desc 'create sample data'
  task create_samples: :environment do
    load './lib/tasks/samples/users_shops_products.rb'
  end

end
