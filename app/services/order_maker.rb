# cancel and make orders on the database and through APIs
class OrderMaker

  attr_reader :identity_solver, :order

  def initialize(identity_solver, order)
    @identity_solver = identity_solver
    @order = order
  end

  # add a whole package set into an order
  def package_set(package_set)
    OrderMaker::PackageSetHandler.new(self, package_set)
  end

  # add a simple sku into an order
  def sku(sku)
    OrderMaker::SkuHandler.new(self, sku)
  end

  # in case of rollback or destroy
  # throughout the subclasses
  # if there are payments involved we try to manage them
  # if the order is not destroyable we will simply cancel it if empty with payments
  # this can occur if someone tries to pay and fail, then delete his items
  def destroy_empty_order!
    # NOTE : we should abstract this whole logic into OrderCanceller and let it find out by itself
    if empty_order?
      order.order_payments.where(status: :scheduled).delete_all
      if order.order_payments.count > 0
        OrderCanceller.new(order).cancel_all!
      end
    end
    if order.destroyable?
      order.remove_coupon(identity_solver) if order.coupon
      order.reload
      order.destroy
    end
  end

  def empty_order?
    order.order_items.count == 0
  end

  # displayable errors linked to the order
  # this is used in all the subclasses
  def order_errors
    order.errors.full_messages.join(', ')
  end

end
