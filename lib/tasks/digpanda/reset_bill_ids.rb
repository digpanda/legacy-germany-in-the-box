class Tasks::Digpanda::ResetBillIds
  def initialize
    reset_all_bill_ids!
    assign_bill_ids!
  end

  private

    def reset_all_bill_ids!
      puts "Numer of bill id before removal : #{bill_count}"
      # we first reset all the bill ids to 0 to start with
      # we skip the callbacks to remove it without any auto make bill id trigger
      Order.skip_callback(:save, :after, :make_bill_id)
      Order.all.each do |order|
        order.bill_id = nil
        order.save(validate: false)
      end
      Order.set_callback(:save, :after, :make_bill_id)
      puts "Number of bill id after removal : #{bill_count}"
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

    def bill_count
      Order.where(:bill_id.ne => nil).count
    end
end
