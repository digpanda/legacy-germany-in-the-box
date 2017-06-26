# manage the package set orders
# NOTE : package set order items are casual order items with customized data
# they aren't differentiated in the system, so there's an interdependency
# with the `SkuHandler` class which has to be taken into consideration
# when you edit this class.
class OrderMaker
  class PackageSetHandler < BaseService

    attr_reader :order_maker, :order, :package_set

    def initialize(order_maker, package_set)
      @order_maker = order_maker
      @order = order_maker.order
      @package_set = package_set
    end

    # add a whole package set into an order
    # we first clean up the package set from the order
    # and iterate it as many times as we need
    def refresh!(quantity, increment: false)
      # if the customer has already this package set
      if increment
        # we artificially increment it if the increment mode is on
        # this will be used specifically on single buttons to add to cart
        quantity = current_quantity + quantity
      end
      capture!
      remove_package_set!
      buyable?
      package_set.package_skus.each do |package_sku|
        quantity.times do
          insert_package_sku!(package_sku)
        end
      end
      return_with(:success)
    rescue OrderMaker::Error => exception
      restore!
      return_with(:error, error: exception.message)
    end

    # remove an order item from the order
    # clean up the order if needed
    def remove!
      if remove_package_set!
        order_maker.destroy_empty_order!
        return_with(:success)
      else
        return_with(:error, error: order_maker.order_errors)
      end
    end

    private

    def current_quantity
      order.package_set_quantity(package_set)
    end

    # TODO : limit the interdependency by making the action linked to the package sku here
    # and not inside sku_handler, like the locking system.
    def insert_package_sku!(package_sku)
      added_item = order_maker.sku(package_sku.sku).with_package_sku(package_sku).refresh!(package_sku.quantity)
      unless added_item.success?
        remove_package_set!
        raise OrderMaker::Error, added_item.error[:error]
      end
    end

    def remove_package_set!
      order.order_items.where(package_set: package_set).delete_all
    end

    # capture the current order_items matching with this package set and convert it into json
    # when it's completely deleted from the database we can then rollback by re-creating everything
    # it's a homemade transaction system because monogid sucks.
    def capture!
      @capture = order.order_items.where(package_set: package_set).map(&:as_json)
    end

    # restore the previously captured order_items in this package_set
    def restore!
      @capture.each do |order_item|
        order.order_items.create!(order_item)
      end
    end

    def buyable?
      unless package_set.active
        raise OrderMaker::Error, "This package set is not available."
      end
    end

  end
end
