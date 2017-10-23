class Customer::CartController < ApplicationController
  attr_reader :user
  attr_reader :orders

  before_action :breadcrumb_cart
  before_action :set_cart

  authorize_resource class: false

  def show
    # if params[:product_id]
    #   product = Product.where(id: params[:product_id]).first
    #
    # end
    #
    # # handling auto adding of package set
    # package_set = PackageSet.find(params[:package_set_id]) if params[:package_set_id]
    # if package_set
    #
    #   order = cart_manager.order(shop: package_set.shop)
    #   order_maker = OrderMaker.new(identity_solver, order)
    #   add = order_maker.package_set(package_set).refresh!(1, increment: true)
    #   if add.success?
    #     cart_manager.store(order)
    #   end
    # end

  end

  private

    def set_cart
      @cart = cart_manager.current_cart
    end
end
