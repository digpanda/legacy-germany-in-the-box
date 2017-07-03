class Admin::Referrers::ProvisionsController < ApplicationController

  attr_accessor :referrer, :referrers, :provision, :provisions

  before_action :set_referrer
  before_action :set_provision, only: [:refresh]

  before_action :breadcrumb_admin_referrers
  before_action :breadcrumb_admin_referrer
  before_action :breadcrumb_admin_referrer_provisions

  authorize_resource :class => false
  layout :custom_sublayout

  def index
  end

  def refresh
    # NOTE : this should be put somewhere else, like in a library
    provision.order.refresh_referrer_provision!
    flash[:success] = "The provision was manually refreshed."
    redirect_to navigation.back(1)
  end

  def set_provision
    @provision = referrer.provisions.find(params[:provision_id] || params[:id])
  end

  def set_referrer
    @referrer = Referrer.find(params[:referrer_id])
  end

end
