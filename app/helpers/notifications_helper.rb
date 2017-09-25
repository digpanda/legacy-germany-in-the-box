module NotificationsHelper
  def notifications?
    current_user&.notifications?
  end
end
