class Guest::PackageSetsController < ApplicationController

  attr_reader :package_set

  before_action :set_package_set

  # we show the list of packages
  # we already created from the admin
  def index
    @package_sets = PackageSet.all
  end

  # we use the package set and convert it into an order
  def update
    # we first compose the whole order
    package_set.package_skus.each do |package_sku|
      order_maker.add(package_sku.sku, package_sku.quantity, package_sku.price)
    end
    # we lock it because it was virtually setup
    order.lock!
    # we first empty the cart manager to make it fresh
    cart_manager.empty!
    cart_manager.store(order)
    redirect_to customer_cart_path
  end

  private

  # to be abstracted somewhere else
  def order_maker
    @order_maker ||= OrderMaker.new(order, bypass_locked: true)
  end

  def order
    @order ||= cart_manager.order(shop: package_set.shop, call_api: false)
  end
  # end of abstraction

  def set_package_set
    @package_set = PackageSet.find(params[:id]) unless params[:id].nil?
  end

end
