class UserDecorator < Draper::Decorator
  PICTURE_URL = '/images/icons/default_user_pic.png'

  include Concerns::Imageable

  delegate_all
  decorates :user

  def readable_role
    if referrer
      'Referrer'
    else
      "#{role.capitalize}"
    end
  end

  def who
    if full_name.present?
      full_name
    elsif nickname.present?
      nickname
    elsif email.present?
      email
    else
      id
    end
  end

  def full_name
    if "#{fname}#{lname}".chinese?
      "#{lname}#{fname}"
    else
      "#{fname} #{lname}"
    end
  end

  def avatar
    if pic.url.nil?
      PICTURE_URL
    else
      image_url(:pic, :thumb)
    end
  end
end
