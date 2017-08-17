class Customer::ReferrerController < ApplicationController
  attr_reader :referrer

  before_action :freeze_header
  before_filter :valid_referrer?
  before_action :set_referrer
  authorize_resource class: false

  def show
  end

  def provision
  end

  # we get the provision rates of all the package sets that are not 0.0
  def provision_rates
    @package_sets = PackageSet.active.where(:referrer_rate.gt => 0.0).order_by(name: :asc).all
  end

  def agb
  end

  def coupons
  end

  def qrcode
  end

  def claim
    if referrer.current_balance < setting.referrer_money_claim
      flash[:error] = I18n.t('referrer.you_cant_claim_your_money', amount: setting.referrer_money_claim)
      redirect_to navigation.back(1)
      return
    end

    Notifier::Admin.new.referrer_claimed_money(referrer)
    flash[:success] = I18n.t('referrer.your_request_was_sent_to_our_operation_team')
    redirect_to navigation.back(1)
  end

  private

    def set_referrer
      @referrer = current_user.referrer
    end

    def valid_referrer?
      unless current_user&.referrer?
        flash[:error] = I18n.t('general.not_allowed_section')
        redirect_to navigation.back(1)
        false
      end
    end
end
