class ReferrerTokenToReferrerGroup < Mongoid::Migration
  def self.up
    ReferrerToken.all.each do |referrer_token|
      puts "Converting ReferrerToken `#{referrer_token.id}` into a ReferrerGroup ..."
      ReferrerGroup.create({
        :id => referrer_token.id,
        :name => referrer_token.group,
        :desc => referrer_token.desc,
        :type => referrer_token.type
        })
      puts "Done"
    end
  end

  def self.down
  end
end
