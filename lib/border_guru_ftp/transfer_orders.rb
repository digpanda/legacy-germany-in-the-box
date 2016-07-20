module BorderGuruFtp
  class TransferOrders

    attr_reader :orders

    def initialize(orders)
      @orders = orders
    end

    def generate_and_store_local
      orders_by_shop.each do |shop_orders|
        Makers::Store.new(shop_orders, orders_csv(shop_orders)).to_local
      end
    end

    def connect_and_push_remote
      orders_csv_files.each do |file_path|
        Senders::Push.new(remote_connection, file_path).to_remote
      end
    end

    def clean_local_storage
      FileUtils.rm_rf(BorderGuruFtp.local_directory)
    end

    private
 
    def remote_connection
      @remote_connection ||= Senders::Connect.new.establish
    end

    def orders_csv_files
      Senders::Prepare.new.fetch
    end
    
    def orders_csv(orders)
      Makers::Generate.new(orders).to_csv
    end

    def orders_by_shop
      @orders_by_shop ||= orders.group_by(&:shop_id).values
    end


  end
end