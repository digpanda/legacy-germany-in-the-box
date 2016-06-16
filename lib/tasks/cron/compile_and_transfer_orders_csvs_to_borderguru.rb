class CompileAndTransferOrdersCsvsToBorderguru

  def initialize

=begin
    Order.all.each do |order|
      order.status = :custom_checking
      order.save
    end

    return
=end

    # To avoid library eager load failure (happens sometimes)
    require "#{::Rails.root}/app/services/turn_orders_into_csv_and_store_it.rb"
    require "#{::Rails.root}/app/services/push_csvs_to_borderguru_ftp.rb"

    devlog "Let's start to fetch all the current orders ..."

    #
    # We check the correct orders via a good old loop system (Viva Mongoid !)
    #
    User.where(role: :shopkeeper).each do |user|

      orders = []

      if user.shop.nil?
        devlog "This user `#{user.id}` has no shop at the moment."
        next
      end

      user.shop.orders.where(status: :custom_checking).each do |order|
        orders  << order
      end

      devlog "`#{orders.length}` orders were found for user [shopkeeper] `#{user.id}`."
 
      # We start by processing into a CSV file
      #
      unless orders.length == 0

        devlog "Let's turn them into a CSV and store it under `/public/uploads/borderguru/#{user.id}/`"

        turned = TurnOrdersIntoCsvAndStoreIt.new(user.shop, orders).perform

        unless turned[:success]
          devlog "A problem occured while preparing the orders (#{turned[:error]})."
          return
        end

      end

    end

    devlog "Now let's push them into BorderGuru FTP. All of them because we are that crazy."

    #
    # We transfer the information to BorderGuru
    # We could avoid opening the file twice but it's a double process.
    #
    files_pushed = PushCsvsToBorderguruFtp.new.perform

    unless files_pushed[:success]
      devlog "A problem occured while transfering the files to BorderGuru (#{files_pushed[:error]})."
      return
    end

    devlog "Successfully transfered files were removed from our own server."
    devlog "Process finished."

  end

  def devlog(content)
    @@devlog ||= Logger.new("#{::Rails.root}/log/borderguru_cron.log")
    @@devlog.info content
    puts content
  end

end