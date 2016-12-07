# cancel orders on the database and through APIs
class OrderMaker < BaseService

  attr_reader :order

  def initialize(order)
    @order = order
  end

  # NOTE : this could be way improved but it was directly
  # taken from the controller and slightly changed
  # maybe, split it up into subclasses for each main method.
  def add(sku, quantity)

    return return_with(:error) unless sku.enough_stock?(quantity)

    existing_order_item = order.order_items.with_sku(sku).first
    if existing_order_item.present?

      existing_order_item.quantity += quantity
      existing_order_item.save!
      return return_with(:success, order: order)

    end

    if refresh_order_items!(sku, quantity)
      return return_with(:success, order: order)
    end

  return_with(:error)
  end


  private

  def refresh_order_items!(sku, quantity)
    order.order_items.build.tap do |order_item|
      order_item.quantity = quantity
      order_item.product = sku.product
      # we clone in a clean way the sku
      # TODO : could be put into the model directly
      SkuCloner.new(order_item, sku, :singular).process
      order_item.sku_origin = sku
    end.save!
  end

  # TODO : we should take back any update and delete linked to the order and put them here.
  # centralization of the system will help change it.

end
