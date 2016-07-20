require 'border_guru_ftp'

class Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru

  def initialize

    require Rails.root.join("app/services/push_csvs_to_borderguru_ftp.rb")

    devlog "Let's start to fetch all the current orders ..."

    orders = Order.where(status: :custom_checking).all

    unless orders.length.zero?

      begin
        BorderGuruFtp.transfer_orders(orders)
      rescue BorderGuruFtp::Error => exception
        devlog "A problem occured while preparing the orders (#{exception.message})."
        return
      end

    end

    devlog "Now let's push them into BorderGuru FTP. All of them because we are that crazy."

    #
    # We transfer the information to BorderGuru
    # We could avoid opening the file twice but it's a double process.
    #
    if Rails.env.production?
      files_pushed = push_csvs_to_borderguru_ftp.perform
      if files_pushed.success?
        push_csvs_to_borderguru_ftp.clean
      else
        devlog "A problem occured while transfering the files to BorderGuru (#{files_pushed.message})."
        return
      end
    else
      push_csvs_to_borderguru_ftp.clean
      devlog "We can't push files to BorderGuru FTP. We are not in production environment."
    end

    devlog "Successfully transfered files were removed from our own server."
    devlog "Process finished."

  end

  def push_csvs_to_borderguru_ftp
    PushCsvsToBorderguruFtp.new
  end

  # should be improved <-- should be placed into the lib itself
  def devlog(content)
    @@devlog ||= Logger.new(Rails.root.join("log/borderguru_cron.log"))
    @@devlog.info content
    puts content
  end

end