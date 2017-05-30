# cancel and make orders on the database and through APIs
class OrderMaker
  class PackageSet

    attr_reader :order, :package_set

    def initialize(order, package_set)
      @order = order
      @package_set = package_set
    end

    # add a whole package set into an order
    def add
      return_with(:error, error: "Package set not buyable.") unless buyable?
      package_set.package_skus.each do |package_sku|
        # to complete
      end
    end

    private

    def buyable?
      package_set.active
    end

  end
end
