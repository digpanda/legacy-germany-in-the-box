class Customer::ReferrerController < ApplicationController

  before_action :freeze_header
  before_filter :valid_referrer?
  before_action :set_referrer
  authorize_resource :class => false

  def show
  end

  def provision
  end

  def coupons
  end

  private

  def set_referrer
    @referrer = current_user.referrer
  end

  def valid_referrer?
    unless current_user&.referrer?
      flash[:error] = I18n.t(:not_allowed_section, scope: :general)
      redirect_to navigation.back(1)
      false
    end
  end

end
