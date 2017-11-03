class RewardManager < BaseService
  class InviteThreeFriends < Base

    # if the user entered a correct email the reward is confirmed
    def process_reward
      if reward.user.friends.count >= 3
        coupon
        return return_with(:success)
      end
      return_with(:error, "You did not invite 3 friends.")
    end

    def readable_to_save
      "Reward is a coupon #{coupon.code} because got many friends."
    end

    # setup email coupon reward to use
    # around 80 CNY with a minimum order of 80 CNY
    def coupon
      @coupon ||= Coupon.create!(user: reward.user, discount: money, minimum_order: money, unit: :value, unique: true)
    end

    def money
      80.in_yuan.to_euro.amount
    end

  end
end
