require 'border_guru_ftp/order_csvs'

module BorderGuruFtp

  Error = Class.new(StandardError)
  
  class << self

    def process_orders(orders)
      OrderCsvs.generate_and_store_local(orders)
    end

  end

end