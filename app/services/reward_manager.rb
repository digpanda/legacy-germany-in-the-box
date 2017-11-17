class RewardManager < BaseService
  attr_reader :user, :task

  def initialize(user, task:)
    @user = user
    @task = task
  end

  # this will not trigger the Reward model entry creation
  # it's used to check if the reward is already in database
  # NOTE : we use that when confirming email for instancei
  # f the user did not start this challenge
  # we don't need to give him a coupon.
  def started?
    reward_exists?
  end

  def ended?
    reward_ended?
  end

  # we simple start or recover the reward
  # if it's already started, it won't affect the data
  def start
    if reward.to_end?
      return_with(:success)
    else
      return_with(:error, "Reward was already given.")
    end
  end

  # we will call a dynamic subclass if defined
  # it will process the reward system
  # if the subclass does not exist it does not process anything
  def end
    task_class.new(reward).end if task_class
  end

  def task_instance
    @task_instance ||= task_class.new(reward)
  end

  # read the reward for each case
  # it was originally thought in case the reward can be changing through time after receiving it
  # but it seems it's not the case anymore as we print out the reward itself as a text.
  def read
    reward.read
  end

  # we can access the reward from the model directly from the manager
  def reward
    @reward ||= matching_rewards.first_or_create!(started_at: Time.now)
  end

  def reward_exists?
    matching_rewards.count > 0
  end

  def reward_ended?
    reward_exists? && !matching_rewards.first.to_end?
  end

  def matching_rewards
    Reward.where(user: user, task: task)
  end

  # to recover things such as #coupon methods
  # from outside the reward manager systme
  def method_missing(method, *params, &block)
    if task_instance.respond_to?(method)
      task_instance.send(method, *params, &block)
    end
  end
  
  private

    def task_class
      "RewardManager::#{task.to_s.camelize}".constantize rescue nil
    end
end
