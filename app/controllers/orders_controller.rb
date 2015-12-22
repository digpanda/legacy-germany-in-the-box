class OrdersController < ApplicationController

    def add_product
      @current_order = current_order

      product = Product.find(params[:product_id])
      existing_order_item = current_order.order_items.to_a.find { |i| i.product.id === product.id }

      if existing_order_item.present?
        existing_order_item.price = product.price
        existing_order_item.weight = product.weight
        existing_order_item.quantity += 1
        existing_order_item.save!
      else
        current_order_item = current_order.order_items.create!
        current_order_item.price = product.price
        current_order_item.weight = product.weight
        current_order_item.quantity = 1
        current_order_item.product = product
        current_order_item.save!
      end

      current_order.save!

      flash[:info] = 'The product has been added to the cart!'
      redirect_to popular_products_path
    end

end
