class Customer::Referrer::CustomizationController < ApplicationController
  attr_reader :referrer, :customization

  before_filter :valid_referrer?
  before_action :set_referrer, :set_customization

  before_action :minimal_layout, only: [:share]

  authorize_resource class: false

  def show
  end

  def update
    if customization.update(customization_params)
      flash[:success] = I18n.t('referrer.customization_updated')
      redirect_to customer_referrer_path
    else
      flash[:error] = "#{customization.errors.full_messages.join(', ')}"
      render :show
    end
  end

  private

    def set_referrer
      @referrer = current_user.referrer
    end

    def set_customization
      @customization = referrer.customization || ReferrerCustomization.create(referrer: referrer)
    end

    def customization_params
      params[:referrer_customization][:active] = true unless params[:referrer_customization][:active]
      params[:referrer_customization].permit!
    end

    def valid_referrer?
      unless current_user&.referrer?
        flash[:error] = I18n.t('general.not_allowed_section')
        redirect_to navigation.back(1)
        false
      end
    end
end
