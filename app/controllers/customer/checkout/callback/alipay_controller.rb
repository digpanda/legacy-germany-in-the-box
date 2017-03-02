class Customer::Checkout::Callback::AlipayController < Customer::AddressesController

  authorize_resource :class => false
  layout :default_layout

  def show

    binding.pry

  end

end
