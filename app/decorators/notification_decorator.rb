class NotificationDecorator < Draper::Decorator

  delegate_all
  decorates :notification

  def read?
    !!(self.read_at)
  end

  def read!
    self.read_at = Time.now.utc
    self.save
  end

end