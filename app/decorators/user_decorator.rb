class UserDecorator < Draper::Decorator

  PICTURE_URL = '/images/icons/default_user_pic.png'
  
  include Imageable

  delegate_all
  decorates :user

  def full_name
    "#{fname} #{lname}"
  end

  def avatar
    if self.pic.url.nil?
     PICTURE_URL
    else
      self.image_url(:pic, :thumb)
    end
  end

end
