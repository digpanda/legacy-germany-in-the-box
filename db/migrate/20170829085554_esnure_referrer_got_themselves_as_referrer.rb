class EsnureReferrerGotThemselvesAsReferrer < Mongoid::Migration
  def self.up
    puts "Looking through all the referrers ..."
    Referrer.all.each do |referrer|
      user = referrer.user
      user.parent_referrer = referrer
      save = user.save!(validate: false)
      puts "Updating Customer #{referrer.user.id} (#{referrer.user.decorate.full_name}) which is Referrer #{referrer.id} (operation : #{save})"
    end
  end

  def self.down
  end
end
