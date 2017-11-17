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
        user.update(vip: true)
      end

      def vipable?
        fill_in_email? && invite_three_friends? && make_first_order?
      end

      def fill_in_email?
         RewardManager.new(user, task: :fill_in_email).ended?
      end

      def invite_three_friends?
        RewardManager.new(user, task: :invite_three_friends).ended?
      end

      def make_first_order?
        RewardManager.new(user, task: :make_first_order).ended?
      end

  end
end
