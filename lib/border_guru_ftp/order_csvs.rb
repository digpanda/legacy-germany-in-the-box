require 'border_guru_ftp/order_csvs/makers/all'

module BorderGuruFtp
  class OrderCsvs

    class << self

      def generate_and_store_local(orders)
        Makers::Store.new(orders, orders_csv(orders)).to_local
      end

      private

      def orders_csv(orders)
        Makers::Generate.new(orders).to_csv
      end

    end

  end
end