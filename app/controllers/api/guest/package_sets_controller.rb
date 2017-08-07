class Api::Guest::PackageSetsController < Api::ApplicationController
  attr_reader :package_set, :quantity

  before_filter do
    restrict_to :customer
  end

  before_action :set_package_set
  before_action :set_quantity, only: [:update]

  # we add the package set with quantity 1 into the order
  # if it's a success, we store the order into the cart
  def create
    add = order_maker.package_set(package_set).refresh!(1, increment: true)
    if add.success?
      cart_manager.store(order)
      render json: { success: true, message: I18n.t(:add_product_ok, scope: :edit_order) }
    else
      render json: throw_error(:unable_to_process).merge(error: add.error[:error])
    end
  end

  def update
    refresh = order_maker.package_set(package_set).refresh!(quantity)
    if refresh.success?
      cart_manager.store(order)
      # the corect rendering is in the views
    else
      render json: throw_error(:unable_to_process).merge(error: refresh.error[:error])
    end
  end

  def destroy
    remove = order_maker.package_set(package_set).remove!

    unless remove.success?
      render json: throw_error(:unable_to_process).merge(error: remove.error[:error])
    end
  end

  private

    def order_maker
      @order_maker ||= OrderMaker.new(identity_solver, order)
    end

    def order
      @order ||= cart_manager.order(shop: package_set.shop)
    end

    def set_package_set
      @package_set = PackageSet.find(params[:package_set_id] || params[:id])
    end

    def set_quantity
      @quantity = params[:quantity].to_i
    end
end
