class FromManyToEmbeddedAddress < Mongoid::Migration
  def self.up

    # process the order multiple addresses
    Order.all.each do |order|
      if order.billing_address_id
        order.billing_address = Address.find(order.billing_address_id).clone
      end
      if order.shipping_address_id
        order.shipping_address = Address.find(order.shipping_address_id).clone
      end
      order.save

      order.reload
      if order.billing_address && order.shipping_address
        # destroying the old data
        # if all went fine
        order.billing_address_id = nil
        order.shipping_address_id = nil
        order.save
      end
    end

    # check every left addresses
    Address.all.each do |address|
      if address.shop_id
        shop = Shop.find(address.shop_id)
        shop.addresses << address.clone
        shop.save
      end

      if address.user_id
        user = User.find(address.user_id)
        user.addresses << address.clone
        user.save
      end
    end

    # if everything went fine, we don't need the old address system anymore
    Address.all.delete_all

  end

  def self.down
  end
end
