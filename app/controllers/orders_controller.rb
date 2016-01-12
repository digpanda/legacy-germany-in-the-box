class OrdersController < ApplicationController

  before_action :authenticate_user!, :except => [:manage_cart, :add_product, :adjust_products_amount]

  def manage_cart
  end

  def set_address_payment
    @address = Address.new
  end

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

      redirect_to manage_cart_path
    end

    def checkout
      current_order.status = :checked_out
      current_order.user = current_user
      current_order.save!
      session.delete(:order_id)
      redirect_to popular_products_path
    end

  def destroy
    Order.find(params[:id]).delete
    redirect_to request.referrer
  end

  def continue
    if session[:order_id] != params[:id]
      session[:order_id] = params[:id]
      flash[:info] = 'You have selected another order to continue!'
    end

    redirect_to manage_cart_path
  end

end
