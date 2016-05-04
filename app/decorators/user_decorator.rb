class UserDecorator < Draper::Decorator

  delegate_all
  decorates :user

  def full_name
    "#{fname} #{lname}"
  end

end
