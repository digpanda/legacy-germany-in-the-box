namespace :cron do

  desc "compile and transfer orders CSVs to borderguru"
  task compile_and_transfer_orders_csvs_to_borderguru: :environment do
    Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru.new.perform
  end

  desc "Transmit PickUp Orders to Hermes via Email"
  task transmit_pickup_orders_to_hermes: :environment do
    Tasks::Cron::TransmitPickupOrdersToHermes.new.perform
  end

  desc "get the shipping ids and sending informations for uncomplete orders from Border Guru"
  task get_missing_shippings_from_border_guru: :environment do
    Tasks::Cron::GetMissingShippingsFromBorderGuru.new.perform
  end

end
