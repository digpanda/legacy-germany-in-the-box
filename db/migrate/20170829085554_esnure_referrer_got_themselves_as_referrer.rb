class EsnureReferrerGotThemselvesAsReferrer < Mongoid::Migration
  def self.up
    puts "Looking through all the referrers ..."
    Referrer.all.each do |referrer|
      unless referrer.user.parent_referrer
        customer.update(parent_referrer: customer.referrer)
        puts "Updating Customer #{customer.id} which is Referrer #{referrer.id}"
      end
    end
  end

  def self.down
  end
end
