class RewardManager < BaseService
  class MakeFirstOrder < Base

    # if the user entered a correct email the reward is confirmed
    def process_reward
      # IF HIM OR HIS FRIENDS MADE A PAID ORDER
      if reward.user.friends.count >= 3
        coupon
        return return_with(:success)
      end
      return_with(:error, I18n.t('reward.error.you_did_not_invite'))
    end

    def readable_to_save
      I18n.t('reward.make_first_order', coupon_code: coupon.code)
    end

    # setup email coupon reward to use
    # around 80 CNY with a minimum order of 80 CNY
    def coupon
      @coupon ||= Coupon.create!(user: reward.user, discount: money, minimum_order: money, unit: :value, unique: true)
    end

    def money
      100.in_yuan.to_euro.amount
    end

  end
end
