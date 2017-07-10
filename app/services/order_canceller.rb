# cancel orders on the database and through APIs
class OrderCanceller < BaseService

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def all!
    # managing possible problems
    unless order.cancellable?
      return return_with(:error, "Impossible to cancel order")
    end
    # we cancel the order
    order.status = :cancelled
    StockManager.new(order).out_order!
    return return_with(:error, order.errors.full_messages.join(', ')) unless order.save
    # we go back now
    return_with(:success)
  end

  private

  # # will physically remove the order
  # # it should be used only if the order was not bought
  # def remove_order!
  #   order.order_payments.where(status: :scheduled).delete_all
  #   if order.order_payments.count > 0
  #     raise Error, "Order cannot be physically removed, some payments were confirmed."
  #   end
  #   order.order_items.delete_all
  #   order.delete
  # end

end
