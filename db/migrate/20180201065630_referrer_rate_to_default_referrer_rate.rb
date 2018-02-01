class ReferrerRateToDefaultReferrerRate < Mongoid::Migration
  def self.up
    PackageSet.all.each do |entry|
      entry.default_referrer_rate = entry.attributes['referrer_rate']
      entry.junior_referrer_rate = entry.attributes['referrer_rate']
      entry.senior_referrer_rate = entry.attributes['referrer_rate']
      entry.save(validate: false)
    end

    Service.all.each do |entry|
      entry.default_referrer_rate = entry.attributes['referrer_rate']
      entry.junior_referrer_rate = entry.attributes['referrer_rate']
      entry.senior_referrer_rate = entry.attributes['referrer_rate']
      entry.save(validate: false)
    end

    Product.all.each do |entry|
      entry.default_referrer_rate = entry.attributes['referrer_rate']
      entry.junior_referrer_rate = entry.attributes['referrer_rate']
      entry.senior_referrer_rate = entry.attributes['referrer_rate']
      entry.save(validate: false)
    end
  end

  def self.down
  end
end
