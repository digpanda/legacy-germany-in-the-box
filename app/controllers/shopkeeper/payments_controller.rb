class Shopkeeper::PaymentsController < ApplicationController
  attr_reader :shop

  authorize_resource class: false
  before_action :set_shop

  layout :custom_sublayout, only: [:index]

  def index
    unless shop.billing_address
      flash[:error] = 'Please add a billing address to access the payment section.'
      redirect_to shopkeeper_addresses_path
    end
  end

  private

    def set_shop
      @shop ||= current_user.shop
    end
end
