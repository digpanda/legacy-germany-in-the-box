namespace :cron do

  desc "compile and transfer orders CSVs to borderguru"
  task compile_and_transfer_orders_csvs_to_borderguru: :environment do
    Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru.new
  end

end
