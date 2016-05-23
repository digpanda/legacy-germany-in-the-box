require 'border_guru'

class OrdersController < ApplicationController

  before_action :authenticate_user!, :except => [:manage_cart, :add_product, :adjust_skus_amount]

  before_action :set_order, only: [:show, :destroy, :continue]

  protect_from_forgery :except => [:checkout_success, :checkout_fail]

  load_and_authorize_resource

  layout :custom_sublayout, only: [:show_orders]

  def show_orders
    render :show_orders
  end

  def show
    @readonly = true
    @currency_code = @order.order_items.first.sku.product.shop.currency.code
  end

  def manage_cart
    @readonly = false
    @carts = current_carts
  end

  def set_address
    @address = Address.new
  end

  def add_product
    product = Product.find(params[:sku][:product_id])
    sku = product.decorate.get_sku(params[:sku][:option_ids].split(','))
    quantity = params[:sku][:quantity].to_i

    existing_order_item = current_order(product.shop.id.to_s).order_items.to_a.find { |i| i.product.id == product.id && i.sku_id == sku.id.to_s}

    if not sku.limited or sku.quantity >= quantity
      if existing_order_item.present?
        existing_order_item.quantity += quantity
        existing_order_item.save!
      else
        current_order_item = current_order(product.shop.id.to_s).order_items.build
        current_order_item.price = sku.price
        current_order_item.quantity = quantity
        current_order_item.weight = sku.weight
        current_order_item.product = product
        current_order_item.product_name = product.name
        current_order_item.sku_id = sku.id.to_s
        current_order_item.option_ids = sku.option_ids
        current_order_item.option_names = get_options(sku)
        current_order_item.save!
      end

      if current_order(product.shop.id.to_s).save
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

  def adjust_skus_amount
    products = params.keys.select { |key| /^cart-quantity-of-product-[a-z0-9]+$/.match(key) }
    existing_order_items = current_order(params[:shop_id]).order_items.to_a;

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
          current_order(params[:shop_id]).order_items.delete(order_item)
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
    cart = current_cart(params[:shop_id])
    order = current_order(params[:shop_id]).update_for_checkout!(current_user, params[:delivery_destination_id], cart.border_guru_quote_id, cart.shipping_cost, cart.tax_and_duty_cost)
    order.save!


    @wirecard = PrepareOrderForWirecardCheckout.perform({

      :user        => current_user,
      :order       => order,
      :merchant_id => Rails.env.production? ? cart.submerchant_id : 'dfc3a296-3faf-4a1d-a075-f72f1b67dd2a', # TO CHANGE DYNAMICALLY
      :secret_key  => "6cbfa34e-91a7-421a-8dde-069fc0f5e0b8", # TO CHANGE DYNAMICALLY 
      :amount      => cart.total,
      :currency    => "CNY"

    })
  end

  def checkout_success
    checkout_callback

    order = Rails.env.production? ? current_order(params[:merchant_account_id]) : current_orders.first[1]
    shop = Rails.env.production? ? Shop.find(params[:merchant_account_id]) : order.order_items.first.sku.product.shop

    shipping = BorderGuru.get_shipping(
        order: order,
        shop: shop,
        country_of_destination: ISO3166::Country.new('CN'),
        currency: 'EUR'
    )

    order.save!

    session[:order_ids].delete(shop.id)
  end

  def checkout_fail
    checkout_callback
  end

  def checkout_callback

    customer_email = params["email"]

    # corrupted transaction detected : not the same email -> should be improved / put somewhere else
    if current_user.email != customer_email
        flash[:error] = "An account conflict occurred. Please contact our support."
        redirect_to root_url and return
    end

    UpdateOrderAndPaymentFromWirecardTransaction.perform(params.symbolize_keys)

  end

=begin
  def checkout_OLD
    current_order = current_order(params[:shop_id])
    current_order.status = :checked_out
    current_order.user = current_user
    current_order.delivery_destination = current_user.addresses.find(params[:delivery_destination_id])

    all_products_available = true;
    shop_total_prices = {}
    product_name = nil
    sku = nil

    current_order.order_items.each do |oi|
      product = oi.product
      sku = oi.sku

      if (not sku.limited) or sku.quantity >= oi.quantity
        all_products_available = true

        if shop_total_prices[product.shop]
          shop_total_prices[product.shop][:value] += sku.price * oi.quantity
        else
          shop_total_prices[product.shop] = { value: sku.price * oi.quantity }
        end  
      else
        all_products_available = false
        product_name = product.name

        break
      end
    end

    if !all_products_available
      msg = I18n.t(:not_all_available, scope: :checkout, :product_name => product_name, :option_names => get_options_txt(sku))

      respond_to do |format|
        format.html {
          flash[:error] = msg
          redirect_to request.referrer
        }

        format.json {
          render :json => { :status => :ko, :msg => msg }, :status => :unprocessable_entity
        }      
      end

      return
    end

    shop, total_price = shop_total_prices.detect { |s, t| t[:value] < s.min_total }

    if shop
      msg = I18n.t(:not_all_min_total_reached, scope: :checkout, :shop_name => shop.name, :total_price => total_price[:value], :currency => shop.currency.code, :min_total => shop.min_total)

      respond_to do |format|
        format.html {
          flash[:error] = msg
          redirect_to request.referrer
        }

        format.json {
          render :json => { :status => :ko, :msg => msg }, :status => :unprocessable_entity
        }
      end

      return
    end

    if current_order.save
      current_order.order_items.each do |oi|
        oi.sku.quantity -= oi.quantity if oi.sku.limited
        oi.price = oi.sku.price
        oi.save!
      end

      session[:order_ids].delete(params[:shop_id])

      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:checkout_ok, scope: :checkout)
          redirect_to popular_products_path
        }

        format.json {
          render :json => { :status => :ok }, :status => :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = current_order.errors.full_messages.first
          redirect_to request.referrer
        }

        format.json {
          render :json => { :status => :ko, :msg => current_order.errors.full_messages.first }, :status => :unprocessable_entity
        }
      end
    end
  end
=end

  def destroy
    shop_id = @order.order_items.first.product.shop.id.to_s
    session[:order_ids].delete(shop_id)

    if @order && @order.status == :new && @order.order_items.delete_all && @order.delete
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
    shop_id = @order.order_items.first.product.shop.id.to_s

    unless (co = current_order(shop_id))
      session[:order_ids][shop_id] = @order.id.to_s
    else
      if @order != co
        @order.order_items.each do |ooi|
          coi = co.order_items.detect { |coi| ooi.sku_id == coi.sku_id }

          if coi
            coi.quantity += ooi.quantity
            coi.save
          else
            sku = ooi.product.decorate.get_sku(ooi.option_ids)
            noi = co.order_items.build
            noi.price = sku.price
            noi.quantity = ooi.quantity
            noi.weight = sku.weight
            noi.product = sku.product
            noi.product_name = sku.product.name
            noi.sku_id = sku.id.to_s
            noi.option_ids = sku.option_ids
            noi.option_names = get_options(sku)
            noi.save
          end

          ooi.delete
        end

        @order.order_items.delete_all
        @order.delete

        flash[:info] = I18n.t(:continue_message, scope: :edit_order)
      end
    end

    redirect_to manage_cart_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def get_options(sku)
    variants = sku.option_ids.map do |oid|
      sku.product.options.detect do |v|
        v.suboptions.find(oid)
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(sku.option_ids[i])
      { name: v.name, option: { name: o.name } }
    end
  end

  def get_options_txt(sku)
    variants = sku.option_ids.map do |oid|
      sku.product.options.detect do |v|
        v.suboptions.find(oid)
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(sku.option_ids[i])
      o.name
    end.join(', ')
  end
end
