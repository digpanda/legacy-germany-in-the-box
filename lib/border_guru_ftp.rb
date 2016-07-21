require 'border_guru_ftp/transfer_orders'

# manage the files between the project and BorderGuru FTP
# pretty self explanatory.
module BorderGuruFtp

  CONFIG = Rails.application.config.border_guru
  Error = Class.new(StandardError)

  class << self

    # give the `orders` model list and it'll make CSV files, store it on local
    # push it into their server and remove it from our local afterwards
    # if anything goes wrong, the files will stay in place at a local level
    # so we can troubleshoot manually
    def transfer_orders(orders)
      TransferOrders.new(orders).tap do |transfer|
        transfer.generate_and_store_local
        transfer.connect_and_push_remote if Rails.env.production?
        transfer.clean_local_storage
      end
    end

    # you can add any BorderGuru FTP specifig logs by doing BorderGuruFtp.log('message')
    def log(content)
      @@log ||= Logger.new(Rails.root.join("log/#{CONFIG[:ftp][:log]}"))
      @@log.info content
      puts content if Rails.env.development?
    end

    # used in some precise point in the lib subclasses
    def local_directory
      @local_directory ||= "#{Rails.root}#{CONFIG[:ftp][:local_directory]}"
    end

  end

end