class ReferrerRateToDefaultReferrerRate < Mongoid::Migration
  def self.up
    PackageSet.all.each do |entry|
      entry.default_referrer_rate = entry.attributes['referrer_rate']
      entry.junior_referrer_rate = entry.attributes['referrer_rate']
      entry.senior_referrer_rate = entry.attributes['referrer_rate']
      entry.save(validate: false)
      puts "PackageSet #{entry.id} updated with new referrer rates"
    end

    Service.all.each do |entry|
      entry.default_referrer_rate = entry.attributes['referrer_rate']
      entry.junior_referrer_rate = entry.attributes['referrer_rate']
      entry.senior_referrer_rate = entry.attributes['referrer_rate']
      entry.save(validate: false)
      puts "Service #{entry.id} updated with new referrer rates"
    end

    Product.all.each do |entry|
      entry.default_referrer_rate = entry.attributes['referrer_rate']
      entry.junior_referrer_rate = entry.attributes['referrer_rate']
      entry.senior_referrer_rate = entry.attributes['referrer_rate']
      entry.save(validate: false)
      puts "Product #{entry.id} updated with new referrer rates"
    end
  end

  def self.down
  end
end
