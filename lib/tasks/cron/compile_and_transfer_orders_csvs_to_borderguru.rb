class Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru

  def initialize

    # To avoid library eager load failure (happens sometimes)
    require Rails.root.join("app/services/turn_orders_into_csv_and_store_it.rb")
    require Rails.root.join("app/services/push_csvs_to_borderguru_ftp.rb")

    devlog "Let's start to fetch all the current orders ..."

    #
    # We check the correct orders via a good old loop system (Viva Mongoid !)
    #
    User.where(role: :shopkeeper).each do |user|

      orders = []

      unless user.shop
        devlog "This user `#{user.id}` has no shop at the moment."
        next
      end

      # THIS SHOULD BE SIMPLIFIED to a simple query (but you know mongo ...)
      user.shop.orders.where(status: :custom_checking).each do |order|
        orders  << order
      end

      devlog "`#{orders.length}` orders were found for user [shopkeeper] `#{user.id}`."
 
      # We start by processing into a CSV file
      #
      unless orders.length == 0

        devlog "Let's turn them into a CSV and store it under `/public/uploads/borderguru/#{user.id}/`"

        turned = turn_orders_into_csv_and_store_it(user, orders)

        unless turned.success?
          devlog "A problem occured while preparing the orders (#{turned.message})."
          return
        end

      end

    end

    devlog "Now let's push them into BorderGuru FTP. All of them because we are that crazy."

    #
    # We transfer the information to BorderGuru
    # We could avoid opening the file twice but it's a double process.
    #
    if Rails.env.production?
      files_pushed = push_csvs_to_borderguru_ftp
      unless files_pushed.success?
        devlog "A problem occured while transfering the files to BorderGuru (#{files_pushed.message})."
        return
      end
    else
      devlog "We can't push files to BorderGuru FTP. We are not in production environment."
    end

    devlog "Successfully transfered files were removed from our own server."
    devlog "Process finished."

  end

  def turn_orders_into_csv_and_store_it(user, orders)
    TurnOrdersIntoCsvAndStoreIt.new(user.shop, orders).perform
  end

  def push_csvs_to_borderguru_ftp
    PushCsvsToBorderguruFtp.new.perform
  end

  def devlog(content)
    @@devlog ||= Logger.new(Rails.root.join("/log/borderguru_cron.log"))
    @@devlog.info content
    puts content if Rails.env.development?
  end

end