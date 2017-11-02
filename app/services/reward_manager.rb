class RewardManager < BaseService
  attr_reader :user, :task

  def initialize(user, task:)
    @user = user
    @task = task
  end

  # we simple start or recover the reward
  # if it's already started, it won't affect the data
  def start
    reward.to_end?
  end

  # we will call a dynamic subclass if defined
  # it will process the reward system
  # if the subclass does not exist it does not process anything
  def end
    task_class.new(reward).end if task_class
  end

  # read the reward for each case
  # it was originally thought in case the reward can be changing through time after receiving it
  # but it seems it's not the case anymore as we print out the reward itself as a text.
  def read
    reward.read
  end

  private

    def reward
      @reward ||= Reward.where(user: user, task: task).first_or_create!(started_at: Time.now)
    end

    def task_class
      "RewardManager::#{task.to_s.camelize}".constantize rescue nil
    end
end
