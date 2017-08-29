class EsnureReferrerGotThemselvesAsReferrer < Mongoid::Migration
  def self.up
    puts "Looking through all the referrers ..."
    Referrer.all.each do |referrer|
      referrer.user.update(parent_referrer: referrer)
      puts "Updating Customer #{referrer.user.id} which is Referrer #{referrer.id}"
    end
  end

  def self.down
  end
end
