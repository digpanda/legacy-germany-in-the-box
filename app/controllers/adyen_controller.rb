class AdyenController < ActionController::Base

  skip_before_action :verify_authenticity_token
  protect_from_forgery :except => [:index]
  
  def index
    # https://test.adyen.com/hpp/select.shtml
  end

  private

end
