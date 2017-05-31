# cancel and make orders on the database and through APIs
class OrderMaker

  attr_reader :identity_solver, :order

  def initialize(identity_solver, order)
    @identity_solver = identity_solver
    @order = order
  end

  # add a whole package set into an order
  def package_set(package_set)
    OrderMaker::PackageSetHandler.new(order, package_set)
  end

  # add a simple sku into an order
  def sku(sku, quantity)
    OrderMaker::SkuHandler.new(order, sku, quantity)
  end

  #### OLD SYSTEM
  #
  # def old_add(sku, product, quantity, price:nil, taxes:nil, locked: false, package_set:nil)
  #
  #   existing_order_item = order.order_items.with_sku(sku).first
  #
  #   # if the order item already exists and isn't locked, we add the quantity
  #   if existing_order_item.present? && !existing_order_item.locked?
  #     sku_origin = existing_order_item.sku_origin
  #
  #     unless sku_origin&.stock_available_in_order?(quantity, existing_order_item.order)
  #       return return_with(:error, error: not_available_msg(product, sku))
  #     end
  #
  #     existing_order_item.quantity += quantity
  #     existing_order_item.save!
  #     return return_with(:success, order_item: existing_order_item, msg: I18n.t(:add_product_ok, scope: :edit_order))
  #   end
  #
  #   unless sku.enough_stock?(quantity)
  #     return return_with(:error, error: not_available_msg(product, sku))
  #   end
  #
  #   order_item = build_order_item!(sku, quantity, price, taxes, locked, package_set)
  #   if order_item.persisted?
  #     return return_with(:success, order_item: order_item, msg: I18n.t(:add_product_ok, scope: :edit_order))
  #   end
  #
  #   return_with(:error, error: I18n.t(:add_product_ko, scope: :edit_order))
  # end
  #
  # def remove_package_set!(package_set)
  #   order.order_items.where(package_set: package_set).delete_all
  # end
  #
  # private
  #
  # def build_order_item!(sku, quantity, price, taxes, locked, package_set)
  #
  #   order.order_items.build.tap do |order_item|
  #     order_item.quantity = quantity
  #     order_item.product = sku.product
  #     # we clone in a clean way the sku
  #     SkuCloner.new(order_item, sku, :singular).process
  #     order_item.sku_origin = sku
  #     # `package_set` may be nil most of the time
  #     order_item.package_set = package_set
  #
  #     if package_set
  #       order_item.referrer_rate = package_set&.referrer_rate || 0.0
  #     else
  #       order_item.referrer_rate = sku.product&.referrer_rate || 0.0
  #     end
  #
  #     update_price!(order_item, price)
  #     update_taxes!(order_item, taxes)
  #     update_locked!(order_item, locked)
  #     order_item.save!
  #     update_shipping!
  #   end
  # end
  #
  # def update_taxes!(order_item, taxes)
  #   # we disable the taxe calculations by adding it manually
  #   if taxes
  #     order_item.taxes_per_unit = taxes
  #   end
  # end
  #
  # # we either add the shipping manually or calculate it
  # def update_shipping!
  #   order.refresh_shipping_cost
  # end
  #
  # def update_price!(order_item, price)
  #   # in some cases we setup the price manually
  #   # in those cases we will slightly change the sku price for this case
  #   # NOTE : we change the sku price of the freshly cloned sku
  #   if price
  #     order_item.price_per_unit = price
  #   end
  # end
  #
  # def update_locked!(order_item, locked)
  #   # we lock the order item if there's the option
  #   # # it'll also bypass the locking for the time being so we can `save!`
  #   # afterwards
  #   if locked
  #     order_item.lock!
  #   end
  # end
  #
  # def not_available_msg(product, sku)
  #   I18n.t(:not_all_available, scope: :checkout,
  #          product_name: product.name,
  #          option_names: sku.display_option_names)
  # end

end
