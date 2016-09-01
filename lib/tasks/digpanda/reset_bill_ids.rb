class Tasks::Digpanda::ResetBillIds

  def initialize
    reset_all_bill_ids!
    assign_bill_ids!
  end

  private

  def reset_all_bill_ids!
    # we first reset all the bill ids to 0 to start with
    # we skip the callbacks to remove it without any auto make bill id trigger
    Order.skip_callback(:save, :after, :make_bill_id)
    Order.all.each do |order|
      order.bill_id = nil
      order.save
    end
    Order.set_callback(:save, :after, :make_bill_id)
  end

  def assign_bill_ids!
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
