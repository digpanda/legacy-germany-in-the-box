class RewardManager < BaseService
  class SampleTask < Base

    # this task is to demonstrate how to setup a reward through this system
    # it is also used lightly on the test area to check consistency of the structure

    def process_reward
      return return_with(:success)
    end

    def readable_to_save
      "This is the reward the customer will read."
    end

  end
end
