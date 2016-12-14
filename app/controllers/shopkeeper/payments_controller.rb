class Shopkeeper::PaymentsController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout, only: [:index]
  before_action :set_shop

  attr_reader :shop

  def index
    unless shop.billing_address
      flash[:error] = "Please add a billing address to access the payment section."
      redirect_to shopkeeper_addresses_path
    end
  end

  private

  def set_shop
    @shop ||= current_user.shop
  end
end
