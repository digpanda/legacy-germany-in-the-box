module Helpers
  module Cart
    def fill_cart_manager!(cart_manager)
      orders = FactoryGirl.create_list(:order, 3)
      cart_manager
      orders.each do |order|
        cart_manager.store(order)
      end
      orders
    end
  end
end
