class RewardsManager < BaseService
  class Base < BaseService
    attr_reader :reward

    def initialize(reward)
      @reward = reward
    end

    def end
      if reward.to_end?
        return reward_was_processed if process_reward.success?
      end
      return_with(:error, "Reward was already given.")
    end

    protected

      # base samples to overwrite
      def process_reward
        return_with(:error)
      end

      def readable_to_save
        ""
      end

    private

      def reward_was_processed
        reward.update!(ended_at: Time.now, readable_reward: readable_to_save)
        return_with(:success, reward: reward)
      end
  end
end
