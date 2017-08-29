class EsnureReferrerGotThemselvesAsReferrer < Mongoid::Migration
  def self.up
    puts "Looking through all the referrers ..."
    Referrer.all.each do |referrer|
      save = referrer.user.update!(parent_referrer: referrer)
      puts "Updating Customer #{referrer.user.id} (#{referrer.user.decorate.full_name}) which is Referrer #{referrer.id} (operation : #{save})"
    end
  end

  def self.down
  end
end
