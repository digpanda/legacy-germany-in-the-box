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
      Senders::Push.new(remote_connection, local_files).to_remote
    end

    def clean_local_storage
      FileUtils.rm_rf(BorderGuruFtp.local_directory)
    end

    private

    def local_files
      Senders::Prepare.new.fetch
    end

    def remote_connection
      @remote_connection ||= Senders::Connect.new.establish
    end

    def orders_csv(orders)
      Makers::Generate.new(orders).to_csv
    end

    def orders_by_shop
      @orders_by_shop ||= orders.group_by(&:shop_id).values
    end


  end
end