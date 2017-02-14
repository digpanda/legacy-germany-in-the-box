class FromManyToEmbeddedAddress < Mongoid::Migration
  def self.up

    # # process the order multiple addresses
    # Order.all.each do |order|
    #   if order.billing_address_id
    #     address = Address.where(id: order.billing_address_id).first
    #     if address
    #       order.billing_address = address.clone
    #     end
    #   end
    #   if order.shipping_address_id
    #     address = Address.where(id: order.billing_address_id).first
    #     if address
    #       order.shipping_address = address.clone
    #     end
    #   end
    #   order.save
    #
    #   order.reload
    #   if order.billing_address && order.shipping_address
    #     # destroying the old data
    #     # if all went fine
    #     order.billing_address_id = nil
    #     order.shipping_address_id = nil
    #     order.save
    #   end
    # end
    #
    # # check every left addresses
    # Address.all.each do |address|
    #   if address.shop_id
    #     shop = Shop.where(id: address.shop_id).first
    #     if shop
    #       shop.addresses << address.clone
    #       shop.save
    #     end
    #   end
    #
    #   if address.user_id
    #     user = User.where(id: address.user_id).first
    #     if user
    #       user.addresses << address.clone
    #       user.save
    #     end
    #   end
    # end
    #
    # # if everything went fine, we don't need the old address system anymore
    # Address.all.delete_all

  end

  def self.down
  end
end
