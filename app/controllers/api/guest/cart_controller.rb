class Api::Guest::CartController < Api::ApplicationController

  attr_reader :order, :package_set

  def total
    render status: :ok,
           json: {success: true, datas: cart_manager.products_number}.to_json
  end

  def destroy_package_set
    @order = Order.find(params[:order_id])
    @package_set = PackageSet.find(params[:package_set_id])
    order.order_items.where(package_set: package_set).delete_all

    if destroy_empty_order!
      if order.coupon
        CouponHandler.new(identity_solver, order.coupon, order).reset
      end
      if @order.persisted?
        render 'api/guest/order_items/update'
      else
        render json: {success: true, order_empty: !@order.persisted?}
      end
    else
      render json: throw_error(:unable_to_process).merge(error: order_item.errors.full_messages.join(', '))
    end
  end

  private

  def destroy_empty_order!
    if @order.destroyable?
      @order.remove_coupon(identity_solver) if order.coupon
      @order.reload
      return @order.destroy
    end

    true
  end

end
