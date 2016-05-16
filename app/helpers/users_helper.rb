module UsersHelper

  def seems_like_a_customer?
    current_user.nil? || current_user.is_customer?
  end

end
