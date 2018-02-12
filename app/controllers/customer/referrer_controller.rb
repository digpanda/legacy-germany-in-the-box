class Customer::ReferrerController < ApplicationController
  attr_reader :referrer

  before_filter :valid_referrer?
  before_filter :valid_group_leader?, only: [:group_insight]
  before_action :set_referrer
  authorize_resource class: false

  def show
  end

  def group_insight
    @referrers = Referrer.where(referrer_group: current_user.referrer.referrer_group).all
  end

  def children_insight
    @children_users = referrer.children_users
  end

  def provision
  end

  # we get the provision rates of all the package sets that are not 0.0
  def provision_rates
    @package_sets = PackageSet.active.where(:default_referrer_rate.gt => 0.0).order_by(name: :asc).all
    @brands = Brand.with_package_sets
    @services = Service.active.where(:default_referrer_rate.gt => 0.0).order_by(name: :asc).all
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

    def valid_group_leader?
      unless current_user&.referrer&.group_leader
        flash[:error] = I18n.t('general.not_allowed_section')
        redirect_to root_path
        false
      end
    end

    def valid_referrer?
      unless current_user&.referrer?
        flash[:error] = I18n.t('general.not_allowed_section')
        redirect_to root_path
        false
      end
    end
end
