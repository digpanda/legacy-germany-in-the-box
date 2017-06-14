# cancel orders on the database and through APIs
class OrderCanceller < BaseService

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def all!
    # managing possible problems
    unless order.decorate.cancellable?
      return return_with(:error, "Impossible to cancel order")
    end
    # we cancel the order
    order.status = :cancelled
    StockManager.new(order).out_order!
    return return_with(:error, order.errors.full_messages.join(', ')) unless order.save
    # we go back now
    return_with(:success)
  end



end
