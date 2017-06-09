class Customer::ReferrerController < ApplicationController

  attr_reader :referrer

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

  def claim
    if referrer.current_balance < setting.referrer_money_claim
      flash[:error] = I18n.t('referrer.you_cant_claim_your_money', amount: setting.referrer_money_claim)
      redirect_to navigation.back(1)
      return
    end

    AdminMailer.notify_claim_money("hr@digpanda.com", referrer.id.to_s).deliver
    flash[:success] = I18n.t('referrer.your_request_was_sent_to_our_operation_team')
    redirect_to navigation.back(1)
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
