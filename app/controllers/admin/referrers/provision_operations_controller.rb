class Admin::Referrers::ProvisionOperationsController < ApplicationController
  attr_accessor :referrer, :referrers

  before_action :set_referrer, :except => [:index, :new]

  authorize_resource class: false
  layout :custom_sublayout

  def create
    operation = ReferrerProvisionOperation.create(operation_params)
    if operation.persisted?
      flash[:success] = "The operation was created."
    else
      flash[:error] = "The operation was not created (#{operation.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

    def set_referrer
      @referrer = Referrer.find(params[:referrer_id])
    end

    def operation_params
      handle_amount_direction!
      params.require(:referrer_provision_operation).permit!.merge({:referrer_id => referrer.id})
    end

    def handle_amount_direction!
      if params[:amount_direction] == "decrease"
        params[:referrer_provision_operation][:amount] = "-#{params[:referrer_provision_operation][:amount]}"
      end
    end
end
