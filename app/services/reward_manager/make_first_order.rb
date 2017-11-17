class RewardManager < BaseService
  class MakeFirstOrder < Base

    # if the user or one of his friends made a complete order
    # we validate the reward
    def process_reward
      if made_complete_order?
        return return_with(:success)
      end
      return_with(:error, I18n.t('reward.error.you_did_not_make_an_order'))
    end

    def readable_to_save
      I18n.t('reward.make_first_order', coupon_code: coupon.code)
    end

    # setup email coupon reward to use
    # around 100 CNY with a minimum order of 100 CNY
    def coupon
      @coupon ||= Coupon.create!(user: reward.user, discount: money, minimum_order: money, unit: :value, unique: true, origin: :reward)
    end

    def money
      100.in_yuan.to_euro.amount
    end

    def made_complete_order?
      return true if reward.user.orders.bought.count > 0
      reward.user.friends.each do |friend|
        if friend.orders.bought.count > 0
          return true
        end
      end
      false
    end

  end
end
