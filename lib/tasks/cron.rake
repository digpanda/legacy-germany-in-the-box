namespace :cron do

  desc "compile and transfer orders CSVs to borderguru"
  task compile_and_transfer_orders_csvs_to_borderguru: :environment do
    Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru.new.perform
  end

  desc "Transmit PickUp Orders to Hermes via Email"
  task transmit_pickup_orders_to_hermes: :environment do
    Tasks::Cron::TransmitPickupOrdersToHermes.new.perform
  end

end
