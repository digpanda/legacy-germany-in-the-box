class MakeBillIdFix < Mongoid::Migration
  def self.up
    puts "Calling rake task `digpanda:reset_bill_ids`"
    Tasks::Digpanda::ResetBillIds.new
  end

  def self.down
  end
end
