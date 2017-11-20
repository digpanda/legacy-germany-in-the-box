class RewardManager < BaseService
  class InviteThreeFriends < Base

    # if the user entered a correct email the reward is confirmed
    def process_reward
      if reward.user.introduced.from_wechat.count >= 10
        coupon
        return return_with(:success)
      end
      return_with(:error, I18n.t('reward.error.you_did_not_invite'))
    end

    def readable_to_save
      I18n.t('reward.invite_three_friends', coupon_code: coupon.code)
    end

    # setup email coupon reward to use
    # around 80 CNY with a minimum order of 80 CNY
    def coupon
      @coupon ||= Coupon.create!(user: reward.user, discount: money, minimum_order: money, unit: :value, unique: true, origin: :reward)
    end

    def money
      150
    end

  end
end
