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
    unless border_guru_cancel_order!
      return return_with(:error, "We could not cancel the order from BorderGuru API")
    end
    # we cancel the order
    order.status = :cancelled
    StockManager.new(order).out_order!
    return return_with(:error, order.errors.full_messages.join(', ')) unless order.save
    # we go back now
    return_with(:success)
  end

  def border_guru_cancel_order!
    BorderGuru.cancel_order(border_guru_shipment_id: order.border_guru_shipment_id)
  rescue StandardError
    false
  end


end
