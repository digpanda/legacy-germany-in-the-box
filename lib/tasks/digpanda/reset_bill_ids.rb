class Tasks::Digpanda::ResetBillIds

  def initialize

    Order.all.each do |order|
      puts "Working on `#{order.id}` from `#{order.c_at}` with status `#{order.status}`"
      order.bill_id = nil
      # on save it will remake automatically the bill assignment
      # if the order was confirmed bought
      order.save
      puts "Final bill id : #{order.bill_id}"
    end

  end

end
