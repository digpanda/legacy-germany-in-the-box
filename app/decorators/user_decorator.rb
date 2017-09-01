class UserDecorator < Draper::Decorator

  PICTURE_URL = '/images/icons/default_user_pic.png'

  include Concerns::Imageable

  delegate_all
  decorates :user

  def readable_role
    if referrer
      "Referrer"
    else
      "#{role.capitalize}"
    end
  end

  def who
    if chinese_full_name.present?
      chinese_full_name
    elsif nickname.present?
      nickname
    elsif email.present?
      email
    else
      id
    end
  end

  def full_name
    "#{fname} #{lname}"
  end

  def chinese_full_name
    "#{lname}#{fname}"
  end

  def avatar
    if pic.url.nil?
     PICTURE_URL
    else
      image_url(:pic, :thumb)
    end
  end
end
