class OrdersController < ApplicationController

  def add_product
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


    def adjust_products_amount
      products = params.keys.select { |key| /^cart-quantity-of-product-[a-z0-9]+$/.match(key) }
      existing_order_items = current_order.order_items.to_a;

      products.each do |p|
        quantity = params[p].to_i
        product_id = p.sub(/cart-quantity-of-product-/, '')
        order_item = existing_order_items.find { |i| i.product.id === product_id }

        if quantity > 0
          order_item.quantity = quantity
        else
          current_order.order_items.delete(order_item)
        end

        order_item.save!
      end

      redirect_to cart_path
    end

    def checkout
      if user_signed_in?
        current_order.status = :checked_out
        current_order.user = current_user
        current_order.save!
        session.delete(:order_id)
        redirect_to popular_products_path
      else
        session[:login_failure_counter] = 1
        flash[:info] = 'You haven\'t logged in.'
        redirect_to request.referrer
      end
    end

  def destroy
    Order.find(params[:id]).delete
    redirect_to request.referrer
  end

  def go_on
    session[:order_id] = params[:id]
    redirect_to cart_path
  end

end
