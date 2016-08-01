class UserDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :user

  def full_name
    "#{fname} #{lname}"
  end

  def avatar
    if self.pic.url.nil?
     '/images/icons/default_user_pic.png'
    else
      self.image_url(:pic, :thumb)
    end
  end

end
