class RemoveAllNullReferrerProvision < Mongoid::Migration
  def self.up
    ReferrerProvision.all.each do |referrer_provision|
      puts "Checking ReferrerProvision `#{referrer_provision.id}`"
      if referrer_provision.provision == 0.0
        referrer_provision.delete
        puts "ReferrerProvision was removed."
      end
    end
  end

  def self.down
  end
end
