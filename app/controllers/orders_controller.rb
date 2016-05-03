class OrdersController < ApplicationController

  before_action :authenticate_user!, :except => [:manage_cart, :add_product, :adjust_products_amount]

  before_action :set_order, only: [:show, :destroy, :continue]

  load_and_authorize_resource

  def show_orders
    render :show_orders, layout: "sublayout/_#{current_user.role.to_s}"
  end

  def show
    @readonly = true
  end

  def manage_cart
    @readonly = false
  end

  def set_address
    @address = Address.new
  end

  def add_product
    product = Product.find(params[:sku][:product_id])
    sku = product.get_sku(params[:sku][:option_ids].split(','))
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

    @order                      = current_order(params[:shop_id])
    @order.status               = :paying
    @order.user                 = current_user
    @order.delivery_destination = current_user.addresses.find(params[:delivery_destination_id])
    @order.desc                 = "" # We should set something here @yl
    @order.save

    # Should be dynamic @yl
    merchant_id = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
    secret_key = "6cbfa34e-91a7-421a-8dde-069fc0f5e0b8"

    # Should build order_payments and link it here

    @wirecard = Wirecard::Customer.new(current_user, {
      
      :merchant_id  => merchant_id,
      :secret_key   => secret_key,
      
      :order_number => @order.id,
      
      :amount       => 1.01,
      :currency     => 'CNY',
      :order_detail => @order.desc,

    })

    order_payment            = OrderPayment.new
    order_payment.merchant_id = merchant_id
    order_payment.request_id = @wirecard.request_id
    order_payment.order_id   = @order.id
    order_payment.amount     = @wirecard.amount
    order_payment.currency   = @wirecard.currency
    order_payment.save

    # TO REMOVE AFTER TESTING THE LIBRARY
    @wirecard = Wirecard::Reseller.new({

      :merchant_id  => merchant_id,

      })

    @wirecard.transaction("mlùkmlùk")

  end

  def checkout_success

    transaction_state = params["transaction_state"]
    transaction_id = params["transaction_id"]
    customer_email = params["email"]
    currency = params["request_amount_currency"]
    merchant_id = params["merchant_account_id"]
    request_id = params["request_id"]
    amount = params["requested_amount"]

    if current_user.email != customer_email
      # There's a pb
      # TODO : manage it
    end

    order_payment = OrderPayment.where({merchant_id: merchant_id, request_id: request_id, amount: amount, currency: currency}).first
    order_payment.status = :checking
    order.transaction_id = transaction_id.save
    order.save

    if (transaction_state == "success")

    @wirecard = Wirecard::Reseller.new({

      :merchant_id  => merchant_id,

      })

    @wirecard.transaction(transaction_id)

    end

=begin
  Parameters: {"psp_name"=>"demo",
   "country"=>"CA", 
   "response_signature"=>"74eb11ab18de0f10ddfe33fcadfafe27468726e1260eca22166971638fade438", 
   "city"=>"Toronto", 
   "provider_status_code_1"=>"", 
   "locale"=>"en", 
   "requested_amount"=>"1.010000", 
   "completion_time_stamp"=>"20160503123048", 
   "provider_status_description_1"=>"", 
   "authorization_code"=>"376641",
    "merchant_account_id"=>"dfc3a296-3faf-4a1d-a075-f72f1b67dd2a", 
    "provider_transaction_reference_id"=>"", 
    "street1"=>"123 test", 
    "state"=>"ON",
     "email"=>"customer01@hotmail.com", 
     "transaction_id"=>"dd7912ce-112a-11e6-9e82-00163e64ea9f", 
     "provider_transaction_id_1"=>"", 
     "status_severity_1"=>"information", 
     "ip_address"=>"127.0.0.1", 
     "transaction_type"=>"debit", 
     "status_code_1"=>"201.0000", 
     "status_description_1"=>"The resource was successfully created.", 
     "transaction_state"=>"success", 
     "requested_amount_currency"=>"CNY", 
     "postal_code"=>"M4P1E8", 
     "request_id"=>"20160503123006-571568b68066513c0b4a43e7-572888df6b710e5189bbb421"}
=end
  end

  def checkout_fail
    binding.pry
  end

  def 

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
            sku = ooi.product.get_sku(ooi.option_ids)
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
