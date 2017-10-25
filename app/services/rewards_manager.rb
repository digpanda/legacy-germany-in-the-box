class RewardsManager < BaseService
  attr_reader :user, :task

  def initialize(user, task:)
    @user = user
    @task = task
  end

  # we simple start or recover the reward
  # if it's already started, it won't affect the data
  def start
    reward
  end

  # we will call a dynamic subclass if defined
  # it will process the reward system
  def end
    task_class.new(reward).end if defined?(task_class)
  end

  # read the reward for each case
  def read
    reward.readable_reward
  end

  private

    def reward
      @reward ||= Reward.where(user: user, task: task).first_or_create!(started_at: Time.now)
    end

    def task_class
      "RewardsManager::#{task.to_s.camelize}".constantize
    end
end
