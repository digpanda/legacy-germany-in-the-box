require 'border_guru_ftp/order_csvs/makers/all'

module BorderGuruFtp
  class OrderCsvs
    
    class << self

      def generate_and_store_local(orders)
        Makers::Store.new(orders, Makers::Generate.new(orders).to_csv).to_local
      end

    end

  end
end