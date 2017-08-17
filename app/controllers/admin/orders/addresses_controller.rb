class Admin::Orders::AddressesController < ApplicationController
  attr_accessor :order, :address

  authorize_resource class: false

  before_action :set_order
  before_action :set_address, only: [:show, :update]

  layout :custom_sublayout

  def index
  end

  def show
  end

  def update
    if address.update(address_params)
      flash[:success] = 'The order address was updated.'
    else
      flash[:error] = "The order address was not updated (#{address.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

    def address_params
      params.require(:address).permit!
    end

    def set_order
      @order = Order.find(params[:order_id])
    end

    # we have 2 possible addresses within the system
    def set_address
      @address = begin
         if order.shipping_address&.id&.to_s == params[:id]
           order.shipping_address
         elsif order.billing_address&.id&.to_s == params[:id]
           order.billing_address
         end
       end
    end
end
