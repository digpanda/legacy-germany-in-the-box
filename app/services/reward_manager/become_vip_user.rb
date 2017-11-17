class RewardManager < BaseService
  class BecomeVipUser < Base

    # if the user or one of his friends made a complete order
    # we validate the reward
    def process_reward
      if vipable?
        turn_to_vip
        return return_with(:success)
      end
      return_with(:error, I18n.t('reward.error.you_cannot_become_vip'))
    end

    def readable_to_save
      I18n.t('reward.become_vip_user')
    end

    private

      def turn_to_vip
        reward.user.update(vip: true)
      end

      def vipable?
        fill_in_email? && invite_three_friends? && make_first_order? && made_three_orders?
      end

      def made_three_orders?
        return true if reward.user.orders.bought.count >= 3
        false
      end
      
      def fill_in_email?
         RewardManager.new(reward.user, task: :fill_in_email).ended?
      end

      def invite_three_friends?
        RewardManager.new(reward.user, task: :invite_three_friends).ended?
      end

      def make_first_order?
        RewardManager.new(reward.user, task: :make_first_order).ended?
      end

  end
end
