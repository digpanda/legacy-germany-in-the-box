# cancel and make orders on the database and through APIs
class OrderMaker < BaseService

  attr_reader :order

  def initialize(order)
    @order = order
  end

  # NOTE : this could be way improved but it was directly
  # taken from the controller and slightly changed
  # maybe, split it up into subclasses for each main method.
  # TODO: This method has been replaced
  # def add(sku, quantity, price:nil, locked: false, package_set:nil)
  #   existing_order_item = order.order_items.with_sku(sku).first
  #
  #   # if the order item already exists and isn't locked, we add the quantity
  #   # NOTE : the loop making the package set should setup the quantity straight
  #   # so it will never pass twice here for the same product, we are safe
  #   # if there's any bug concerning this area, making double for no reason, check this out.
  #   if existing_order_item.present? && !existing_order_item.locked?
  #     existing_order_item.quantity += quantity
  #     existing_order_item.save!
  #     return return_with(:success, order_item: existing_order_item)
  #   end
  #
  #   order_item = build_order_item!(sku, quantity, price, locked, package_set)
  #   if order_item.persisted?
  #     return return_with(:success, order_item: order_item)
  #   end
  #
  # return_with(:error, error: I18n.t(:add_product_ko, scope: :edit_order))
  # end

  def add(sku, product, quantity, price:nil, taxes:nil, shipping:nil, locked: false, package_set:nil)
    existing_order_item = order.order_items.with_sku(sku).first

    # if the order item already exists and isn't locked, we add the quantity
    if existing_order_item.present? && !existing_order_item.locked?
      sku_origin = existing_order_item.sku_origin

      unless sku_origin&.stock_available_in_order?(quantity, existing_order_item.order)
        return return_with(:error, error: not_available_msg(product, sku))
      end

      existing_order_item.quantity += quantity
      existing_order_item.save!
      return return_with(:success, order_item: existing_order_item, msg: I18n.t(:add_product_ok, scope: :edit_order))
    end

    unless sku.enough_stock?(quantity)
      return return_with(:error, error: not_available_msg(product, sku))
    end


    order_item = build_order_item!(sku, quantity, price, taxes, shipping, locked, package_set)
    if order_item.persisted?
      return return_with(:success, order_item: order_item, msg: I18n.t(:add_product_ok, scope: :edit_order))
    end

    return_with(:error, error: I18n.t(:add_product_ko, scope: :edit_order))
  end


  private

  def build_order_item!(sku, quantity, price, taxes, shipping, locked, package_set)

    order.order_items.build.tap do |order_item|
      order_item.quantity = quantity
      order_item.product = sku.product
      # we clone in a clean way the sku
      # TODO : could be put into the model directly
      SkuCloner.new(order_item, sku, :singular).process
      order_item.sku_origin = sku
      # `package_set` may be nil most of the time
      order_item.package_set = package_set
      update_price!(order_item, price)
      update_taxes!(order_item, taxes)
      update_shipping!(order_item, shipping)
      update_locked!(order_item, locked)
      order_item.save!
    end
  end

  def update_taxes!(order_item, taxes)
    # we disable the taxe calculations by adding it manually
    if taxes
      order_item.manual_taxes = taxes
    end
  end

  def update_shipping!(order_item, shipping)
    # we disable the taxe calculations by adding it manually
    if shipping
      order_item.manual_shipping_cost = shipping
    end
  end

  def update_price!(order_item, price)
    # in some cases we setup the price manually
    # in those cases we will slightly change the sku price for this case
    # NOTE : we change the sku price of the freshly cloned sku
    if price
      order_item.sku.price = price
    end
  end

  def update_locked!(order_item, locked)
    # we lock the order item if there's the option
    # # it'll also bypass the locking for the time being so we can `save!`
    # afterwards
    if locked
      order_item.lock!
    end
  end

  def not_available_msg(product, sku)
    I18n.t(:not_all_available, scope: :checkout,
           product_name: product.name,
           option_names: sku.option_names.join(', '))
  end

  # TODO : we should take back any update and delete linked to the order and put them here.
  # centralization of the system will help change it.

end
