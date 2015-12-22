class OrdersController < ApplicationController

    def add_product
      @current_order = current_order
      current_order_item = current_order.order_items.create!
      product = Product.find(params[:product_id])
      current_order_item.price = product.price
      current_order_item.weight = product.weight
      current_order_item.product = product
      current_order_item.save!
      current_order.save!

      redirect_to popular_products_path
    end

end