class UserDecorator < Draper::Decorator

  PICTURE_URL = '/images/icons/default_user_pic.png'

  include Imageable

  delegate_all
  decorates :user

  def full_name
    "#{fname} #{lname}"
  end

  def avatar
    if pic.url.nil?
     PICTURE_URL
    else
      image_url(:pic, :thumb)
    end
  end

  def new_notifications?
    notifications.unreads.count > 0
  end

  def admin?
    self.role == :admin
  end

  def shopkeeper?
    self.role == :shopkeeper
  end

  def customer?
    self.role == :customer
  end

  # TODO : to remove when update of user will be refactored completely (shopkeeper and admin too)
  def update_with_password(params, *options)

    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
