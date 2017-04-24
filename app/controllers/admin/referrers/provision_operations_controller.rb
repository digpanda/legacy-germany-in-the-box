class Admin::Referrers::ProvisionOperationsController < ApplicationController

  attr_accessor :referrer, :referrers

  before_action :set_referrer, :except => [:index, :new]

  authorize_resource :class => false
  layout :custom_sublayout

  def create
    operation = ReferrerProvisionOperation.create(operation_params)
    if operation
      flash[:success] = "The operation was created."
    else
      flash[:error] = "The operation was not created (#{operation.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def set_referrer
    @referrer = Referrer.find(params[:referrer_id])
  end

  def operation_params
    params.require(:referrer_provision_operation).permit!.merge({:referrer_id => referrer.id})
  end


end
