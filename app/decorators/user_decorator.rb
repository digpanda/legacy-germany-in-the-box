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
      self.decorator.image_url(:pic, :thumb)
    end
  end

  private

  def thumb_params
    Rails.configuration.logo_image_thumbnail
  end

  def detail_params
    Rails.configuration.logo_image_detailview
  end

end
