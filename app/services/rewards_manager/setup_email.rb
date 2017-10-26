class RewardsManager < BaseService
  class SetupEmail < Base

    # if the user entered a correct email the reward is confirmed
    def process_reward
      if reward.user.valid_email?
        coupon
        return return_with(:success)
      end
      return_with(:error)
    end

    def readable_to_save
      "Reward is a coupon #{coupon.code} because you are a good buddy."
    end

    # setup email coupon reward to use
    def coupon
      @coupon ||= Coupon.create!(user: reward.user, discount: 10.0, unit: :percent, unique: true)
    end

  end
end
