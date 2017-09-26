# cancel orders on the database and through APIs
class OrderCanceller < BaseService
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def all!
    # NOTE : destroy isn't tested nor functional so far.
    # if order.bought?
    cancel
    # else
    #   destroy
    # end
  end

  private

    def destroy
      order.order_payments.where(status: :scheduled).delete_all
      if order.order_payments.count > 0
        return return_with(:error, 'Order cannot be physically removed, some payments were confirmed.')
      end
      order.order_items.delete_all
      order.remove_coupon(identity_solver) if order.coupon
      order.delete
    end

    def cancel
      # should never happen but it's
      # a supplementary protection
      unless order.cancellable?
        return return_with(:error, 'Impossible to cancel order')
      end
      # we cancel the order
      order.status = :cancelled
      stock_manager.out_order!

      if order.save
        return_with(:success)
      else
        return_with(:error, order.errors.full_messages.join(', '))
      end
    end

    def stock_manager
      @stock_manager ||= StockManager.new(order)
    end
end
