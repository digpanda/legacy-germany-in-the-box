class DoubleReferrerFixAgain < Mongoid::Migration
  def self.up
    referrer = Referrer.where(id: "5a54ee727302fc4dadfee6d1").first
    if referrer
      puts "Referrer #{referrer.id} was found."
      referrer.delete
      puts "It was removed."
    end
  end

  def self.down
  end
end
