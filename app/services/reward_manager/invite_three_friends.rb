class RewardManager < BaseService
  class InviteThreeFriends < Base

    # if the user entered a correct email the reward is confirmed
    def process_reward
      if reward.user.friends.count >= 3
        coupon
        return return_with(:success)
      end
      return_with(:error)
    end

    def readable_to_save
      "Reward is a coupon #{coupon.code} because got many friends."
    end

    # setup email coupon reward to use
    # around 80 CNY with a minimum order of 80 CNY
    def coupon
      @coupon ||= Coupon.create!(user: reward.user, discount: 10, minimum_order: 10, unit: :value, unique: true)
    end

  end
end
