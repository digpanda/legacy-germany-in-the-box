class DoubleReferrerFix < Mongoid::Migration
  def self.up
    referrer = Referrer.where(id: "5a3844d37302fc6915c327f7").first
    if referrer
      puts "Referrer #{referrer.id} was found."
      referrer.delete
      puts "It was removed."
    end
  end

  def self.down
  end
end
