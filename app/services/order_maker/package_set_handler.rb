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
    def refresh!(quantity)
      remove_package_set!
      package_set.package_skus.each do |package_sku|
        quantity.times do
          insert_package_sku!(package_sku)
        end
      end
      # TODO : don't forget to manage the `buyable?` condition at the beginning
      # TODO : find a smart way to handle `the coupon refreshing and recalibration of the system
      # NOTE : maybe it will be naturally done via the interdependency of the other class
      return_with(:success)
    rescue OrderMaker::Error => exception
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

    # TODO : limit the interdependency by making the action linked to the package sku here
    # and not inside sku_handler, like the locking system.
    def insert_package_sku!(package_sku)
      added_item = order_maker.sku(package_sku.sku).with_package_sku(package_sku).refresh!(package_sku.quantity)
      unless added_item.success?
        # we need to rollback the order
        rollback_package_set!
        raise OrderMaker::Error, added_item.error[:error]
      end
    end

    # if something bad happens we should systematically rollback
    # the whole package set insertion
    def rollback_package_set!
      remove_package_set!
      order_maker.destroy_empty_order!
    end

    def remove_package_set!
      order.order_items.where(package_set: package_set).delete_all
    end

    def buyable?
      package_set.active
    end

  end
end
