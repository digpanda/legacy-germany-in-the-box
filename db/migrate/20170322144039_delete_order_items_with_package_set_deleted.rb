class DeleteOrderItemsWithPackageSetDeleted < Mongoid::Migration
  def self.up
    OrderItem.not.where(package_set_id: nil).each do |order_item|
      if PackageSet.where(id: order_item.package_set_id).first.nil?
        order_item.delete
      end
    end
  end

  def self.down
  end
end