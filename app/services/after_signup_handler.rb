class AfterSignupHandler
  include Rails.application.routes.url_helpers

  attr_reader :request, :user

  def initialize(request, user)
    @request = request
    @user = user
  end

  # not much to do here yet, we just dispatch a Keen Event
  def solve
    if user.role == :customer
      EventDispatcher.new.customer_was_registered(user).with_geo(ip: request.remote_ip).dispatch!
    end
  end
end
