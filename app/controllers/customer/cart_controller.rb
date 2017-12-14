class Customer::CartController < ApplicationController
  attr_reader :user
  attr_reader :orders
  
  before_action :set_cart

  authorize_resource class: false

  def show
    handle_package_set_add
  end

  private

    # NOTE : maybe we should make another layer to handle
    # adding package set into orders / carts automatically
    def handle_package_set_add
      if package_set
        order = cart_manager.order(shop: package_set.shop)
        order_maker = OrderMaker.new(identity_solver, order)
        add = order_maker.package_set(package_set).refresh!(1, increment: true)
        if add.success?
          cart_manager.store(order)
        end
      end
    end

    def package_set
      PackageSet.find(params[:package_set_id]) if params[:package_set_id]
    rescue Mongoid::Errors::DocumentNotFound
      # we need to rescue to avoid crashing the application
    end

    def set_cart
      @cart = cart_manager.current_cart
    end
end
