class TurnReferrerIntoTable < Mongoid::Migration
  def self.up

    User.with_referrer.each do |user|
      Referrer.create(user: user,
                      reference_id: user.referrer_id,
                      nickname: user.referrer_nickname,
                      group: user.referrer_group)
    end

  end

  def self.down
  end
end
