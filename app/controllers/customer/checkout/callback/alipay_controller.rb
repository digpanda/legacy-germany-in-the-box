class Customer::Checkout::Callback::AlipayController < ApplicationController

  authorize_resource :class => false
  layout :default_layout

  def show

    binding.pry

  end

end
