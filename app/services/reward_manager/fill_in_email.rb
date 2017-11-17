class RewardManager < BaseService
  class FillInEmail < Base

    # if the user entered a correct email the reward is confirmed
    def process_reward
      if reward.user.valid_email? && reward.user.confirmed?
        coupon
        return return_with(:success)
      end
      return_with(:error, I18n.t('reward.error.email_not_valid'))
    end

    def readable_to_save
      I18n.t('reward.fill_in_email', coupon_code: coupon.code)
    end

    # setup email coupon reward to use
    # around 50 CNY with a minimum order of 50 CNY
    def coupon
      @coupon ||= Coupon.create!(user: reward.user, discount: money, minimum_order: money, unit: :value, unique: true, origin: :reward)
    end

    def money
      50.in_yuan.to_euro.amount
    end

  end
end
