module UserHelper
  def referrer?
    current_user&.referrer?
  end

end
