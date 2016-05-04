class Admin::PaymentsController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout, only: [:index]

  def index

    @order_payments = OrderPayment.order_by(c_at: :desc)
    
  end

end