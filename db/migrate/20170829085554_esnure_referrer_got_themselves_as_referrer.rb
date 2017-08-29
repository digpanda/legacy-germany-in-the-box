class EsnureReferrerGotThemselvesAsReferrer < Mongoid::Migration
  def self.up
    puts "Looking through all the referrers ..."
    Referrer.all.each do |referrer|
      tour_guide_user = referrer.user
      unless tour_guide_user.parent_referrer
        tour_guide_user.update(parent_referrer: referrer)
        puts "Updating Customer #{tour_guide_user.id} which is Referrer #{referrer.id}"
      end
    end
  end

  def self.down
  end
end
