class Api::Guest::PackageSetsController < Api::ApplicationController

  attr_reader :package_set

  before_filter do
    restrict_to :customer
  end

  before_action :set_package_set

  # we use the package set and convert it into an order
  def update
    if package_set.active
      # we first compose the whole order
      package_set.package_skus.each do |package_sku|
        # we also lock each order item we generate
        order_maker.add(package_sku.sku, package_sku.product, package_sku.quantity,
                        price: package_sku.price,
                        taxes: package_sku.taxes_per_unit,
                        shipping: package_sku.shipping_per_unit,
                        locked: true,
                        package_set: package_sku.package_set)
      end
      order.update(referrer_rate: package_set.referrer_rate)
      # we first empty the cart manager to make it fresh
      # cart_manager.empty! <-- to avoid multiple package order
      cart_manager.store(order)
      render json: {success: true, msg: I18n.t(:package_set_added, scope: :cart)}
    end
  end

  def set_quantity
    quantity = params[:quantity]

    order.order_items.where(package_set_id: params[:id]).delete

    (quantity.to_i).times do
      add_package_set
    end

    render 'api/guest/order_items/update'
  end

  private

  def order_maker
    @order_maker ||= OrderMaker.new(order)
  end

  def order
    @order ||= cart_manager.order(shop: package_set.shop, call_api: false)
  end

  def set_package_set
    params[:id] ||= params[:package_set_id]
    @package_set = PackageSet.find(params[:id]) unless params[:id].nil?
  end

  def add_package_set
    if package_set.active
      # we first compose the whole order
      package_set.package_skus.each do |package_sku|
        # we also lock each order item we generate
        order_maker.add(package_sku.sku, package_sku.product, package_sku.quantity,
                        price: package_sku.price,
                        taxes: package_sku.taxes_per_unit,
                        shipping: package_sku.shipping_per_unit,
                        locked: true,
                        package_set: package_sku.package_set)
      end
      order.update(referrer_rate: package_set.referrer_rate)
      # we first empty the cart manager to make it fresh
      # cart_manager.empty! <-- to avoid multiple package order
      cart_manager.store(order)
    end
  end

end
