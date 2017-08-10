# all events related to the referrer binding process
class ReferrerBinding
  attr_reader :referrer

  def initialize(referrer)
    @referrer = referrer
  end

  def bind(user)
    unless user.parent_referred_at
      user.parent_referred_at = Time.now
      user.save
    end

    # protection if user has not already a parent_referrer
    if user.parent_referrer
      slack.message "User already got a referrer `#{user.parent_referrer.id}`"
    else
      # now we can safely bind them together
      referrer.children_users << user
      referrer.save
    end
  end

  private

    def slack
      @slack ||= SlackDispatcher.new
    end
end
