# this will basically make all delivery_later being delivered now for testing purpose
# it is used in the notifier system for instance
class ActionMailer::MessageDelivery
  def deliver_later(options={})
    deliver_now
  end
end
