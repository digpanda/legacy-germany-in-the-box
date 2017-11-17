class RewardManager < BaseService
  class Base < BaseService
    attr_reader :reward

    def initialize(reward)
      @reward = reward
    end

    def end
      if reward.to_end?
        if process_reward.success?
          return reward_was_processed
        else
          return process_reward
        end
      end
      return_with(:error, "Reward was already given.")
    end

    protected

      # process reward should return a `return_with` which check if the user is rewardable.
      # if so, the reward will be confirmed and processed by applying `reward_was_processed` automatically
      # a reward will be processed only once, unless an error is returned.
      # the #redable_to_save method is here to be stored permanently in the database as the readable reward
      # it'll be dispatch as notification, etc. and can't be changed afterwards.

      # base samples to overwrite
      def process_reward
        return_with(:error)
      end

      def readable_to_save
        ""
      end

    private

      def reward_was_processed
        reward.update!(ended_at: Time.now, read: readable_to_save)
        dispatch_notification
        return_with(:success, reward: reward)
      end

      def dispatch_notification
        Notifier::Customer.new(reward.user).reward_was_given(reward)
      end
  end
end
