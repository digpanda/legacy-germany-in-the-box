namespace :cron do

  desc "compile and transfer orders CSVs to borderguru"
  task compile_and_transfer_orders_csvs_to_borderguru: :environment do
    load './lib/tasks/cron/compile_and_transfer_orders_csvs_to_borderguru.rb'
    CompileAndTransferOrdersCsvsToBorderguru.new
  end

end
