class Admin::Referrers::ProvisionsController < ApplicationController
  attr_reader :referrer, :referrers, :provision, :provisions

  before_action :set_referrer
  before_action :set_provision

  before_action :breadcrumb_admin_referrers
  before_action :breadcrumb_admin_referrer
  before_action :breadcrumb_admin_referrer_provisions
  before_action :breadcrumb_admin_referrer_provision

  authorize_resource class: false
  layout :custom_sublayout

  def show
  end

  # NOTE : we keep it here but it's currently not used in the system as Provision
  # are created from other areas or/and automatically
  # def create
  #   provision = ReferrerProvision.create(provision_params)
  #   if provision.persisted?
  #     flash[:success] = 'The provision was created.'
  #   else
  #     flash[:error] = "The provision was not created (#{provision.errors.full_messages.join(', ')})"
  #   end
  #   redirect_to navigation.back(1)
  # end

  def update
    if provision.update(provision_params)
      flash[:success] = 'The provision was updated.'
      redirect_to navigation.back(1)
    else
      flash[:error] = "The provision was not updated (#{provision.errors.full_messages.join(', ')})"
      render :show
    end
  end

  def refresh
    if provision.order
      provision.order.refresh_referrer_provision
      flash[:success] = 'The provision was manually refreshed.'
    else
      flash[:error] = 'The refresh functionality works only with provisions linked to orders.'
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if provision.destroy
      flash[:success] = 'The provision was successfully destroyed.'
    else
      flash[:error] = "The provision was not destroyed (#{provision.errors.full_messages.join(', ')})"
    end
    redirect_to admin_referrer_path(referrer)
  end

  private

    def provision_params
      params.require(:referrer_provision).permit!
    end

    def set_provision
      @provision = referrer.provisions.find(params[:provision_id] || params[:id])
    end

    def set_referrer
      @referrer = Referrer.find(params[:referrer_id])
    end
end
