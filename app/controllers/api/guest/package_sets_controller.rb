class Api::Guest::PackageSetsController < Api::ApplicationController

  attr_reader :package_set

  before_filter do
    restrict_to :customer
  end

  before_action :set_package_set

  # we add the sku through the order maker and check success
  # if it's a success, we store the order into the cart
  def create
    add_package_set = order_maker.package_set(package_set).add!
    if add_package_set.success?
      cart_manager.store(order)
      render json: {success: true, message: I18n.t(:add_product_ok, scope: :edit_order)}
    else
      render json: throw_error(:unable_to_process).merge(error: add_package_set.error[:error])
    end
  end

  # OLD CODE BELOW

  def update
    quantity = params[:quantity]

    order.order_items.where(package_set: package_set).delete

    (quantity.to_i).times do
      add_package_set
    end

    handle_coupon!
  end

  def destroy

    order.order_items.where(package_set: package_set).delete_all

    if destroy_empty_order!
      handle_coupon!
      if order.persisted?
        render 'api/guest/order_items/update'
      else
        render json: {success: true, order_empty: !@order.persisted?}
      end
    else
      render json: throw_error(:unable_to_process).merge(error: order_item.errors.full_messages.join(', '))
    end
  end

  private

  # NOTE : this has been moved into the order maker logic
  def handle_coupon!
    coupon_handler.reset if order.coupon
  end

  def destroy_empty_order!
    if order.destroyable?
      order.remove_coupon(identity_solver) if order.coupon
      order.reload
      return order.destroy
    end
    true
  end

  private

  def order_maker
    @order_maker ||= OrderMaker.new(identity_solver, order)
  end

  def order
    @order ||= cart_manager.order(shop: package_set.shop, call_api: false)
  end

  def set_package_set
    @package_set = PackageSet.find(params[:package_set_id] || params[:id])
  end

  # THIS IS FOR UPDATE AND SHOULD BE CHANGED AND REMOVED

  # def add_package_set
  #   if package_set.active
  #     # we first compose the whole order
  #     package_set.package_skus.each do |package_sku|
  #       # we also lock each order item we generate
  #       order_maker.add(package_sku.sku, package_sku.product, package_sku.quantity,
  #       price: package_sku.price,
  #       taxes: package_sku.taxes_per_unit,
  #       locked: true,
  #       package_set: package_sku.package_set)
  #     end
  #     # we first empty the cart manager to make it fresh
  #     # cart_manager.empty! <-- to avoid multiple package order
  #     cart_manager.store(order)
  #   end
  # end

end
