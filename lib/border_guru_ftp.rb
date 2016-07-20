require 'border_guru_ftp/transfer_orders'

module BorderGuruFtp

  CONFIG = Rails.application.config.border_guru
  Error = Class.new(StandardError)

  class << self

    def transfer_orders(orders)
      TransferOrders.new(orders).tap do |transfer|
        transfer.generate_and_store_local
        transfer.connect_and_push_remote if Rails.env.production?
        transfer.clean_local_storage
      end
    end

    def log(content)
      @@log ||= Logger.new(Rails.root.join("log/#{CONFIG[:ftp][:log]}"))
      @@log.info content
      puts content unless Rails.env.production?
    end

    def local_directory
      @local_directory ||= "#{Rails.root}#{CONFIG[:ftp][:local_directory]}"
    end

  end

end