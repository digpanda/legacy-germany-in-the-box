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
  def destroy_empty_order!
    if order.destroyable?
      order.remove_coupon(identity_solver) if order.coupon
      order.reload
      order.destroy
    end
  end

  # displayable errors linked to the order
  # this is used in all the subclasses
  def order_errors
    order.errors.full_messages.join(', ')
  end

end
