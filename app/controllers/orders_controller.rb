class OrdersController < ApplicationController

  before_action :authenticate_user!, :except => [:manage_cart, :add_product, :adjust_products_amount]
  acts_as_token_authentication_handler_for User, except: [:manage_cart, :add_product, :adjust_products_amount]

  before_action :set_order, only: [:show, :destroy, :continue]

  def show
    @readonly = true
  end

  def manage_cart
    @readonly = false
    @order = current_order
  end

  def set_address_payment
    @address = Address.new
  end

  def add_product
    product = Product.find(params[:product_id])
    existing_order_item = current_order.order_items.to_a.find { |i| i.product.id === product.id }

    if not product.limited or product.inventory > 0
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

      if current_order.save
        respond_to do |format|
          format.html {
            flash[:info] = I18n.t(:add_product_ok, scope: :edit_order)
            redirect_to request.referrer
          }

          format.json {
            render :json => { :status => :ok }, :status => :ok
          }
        end
      end

      return
    end

    respond_to do |format|
      format.html {
        flash[:error] = I18n.t(:add_product_ko, scope: :edit_order)
        redirect_to request.referrer
      }

      format.json {
        render :json => { :status => :ko }, :status => :unprocessable_entity
      }
    end
  end

  def adjust_products_amount
    products = params.keys.select { |key| /^cart-quantity-of-product-[a-z0-9]+$/.match(key) }
    existing_order_items = current_order.order_items.to_a;

    all_available = true;

    products.each do |p|
      quantity = params[p].to_i
      product_id = p.sub(/cart-quantity-of-product-/, '')

      product = Product.find(product_id)

      if all_available && quantity >= 0 && ( not product.limited or product.inventory >= quantity )
        all_available = true
      else
        all_available = false
        break
      end
    end

    if all_available
      products.each do |p|
        quantity = params[p].to_i
        product_id = p.sub(/cart-quantity-of-product-/, '')
        order_item = existing_order_items.find { |i| i.product.id === product_id }

        if quantity > 0
          order_item.quantity = quantity
        else
          current_order.order_items.delete(order_item)
        end

        if order_item.save
          flash[:success] = I18n.t(:adjust_product_ok, scope: :edit_order)
          redirect_to manage_cart_orders_path

          return
        end
      end
    end

    flash[:error] = I18n.t(:adjust_product_ko, scope: :edit_order)
    redirect_to manage_cart_orders_path
  end

  def checkout
    current_order.status = :checked_out
    current_order.user = current_user
    current_order.delivery_destination = current_user.addresses.detect { |a| a.id.to_s == params[:delivery_destination_id] }

    all_available = true;
    product_name = ''

    current_order.order_items.each do |oi|
      product = oi.product

      if all_available && ( not product.limited or product.inventory >= oi.quantity )
        all_available = true
      else
        all_available = false
        product_name = product.name
        break
      end
    end

    if all_available && current_order.save
      current_order.order_items.each do |oi|
        oi.product.inventory -= oi.quantity
        oi.product.save
      end

      session.delete(:order_id)

      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:checkout_ok, scope: :checkout)
          redirect_to list_popular_products_path
        }

        format.json {
          render :json => { :status => :ok }, :status => :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = I18n.t(:checkout_ko, scope: :checkout, :product_name => product_name)
          redirect_to request.referrer
        }

        format.json {
          render :json => { :status => :ko }, :status => :unprocessable_entity
        }
      end
    end
  end

  def destroy
    if @order && @order.delete
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:delete_ok, scope: :edit_order)
          redirect_to request.referrer
        }

        format.json {
          render :json => { :status => :ok }, :status => :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = I18n.t(:delete_ko, scope: :edit_order)
          redirect_to request.referrer.merge(:params)
        }

        format.json {
          render :json => { :status => :ko }, :status => :unprocessable_entity
        }
      end
    end
  end

  def continue
    if @order && current_order != @order
      session[:order_id] = params[:id]
      flash[:info] = I18n.t(:continue_message, scope: :edit_order)
    end

    redirect_to manage_cart_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
