class AddressCountryNormalization < Mongoid::Migration
  def self.up

    puts "Shop ..."
    Shop.all.each do |shop|
      shop.addresses.each do |address|
        if address.country == :CN
          address.country = :china
        else
          address.country = :europe
        end
        puts "Address #{address.id} updated"
        address.save!(validate: false)
      end
    end

    puts "User ..."
    User.all.each do |user|
      user.addresses.each do |address|
        if address.country == :CN
          address.country = :china
        else
          address.country = :europe
        end
        puts "Address #{address.id} updated"
        address.save!(validate: false)
      end
    end

    puts "Order ..."
    Order.all.each do |order|
      address = order.billing_address
      if address
        if address.country == :CN
          address.country = :china
        else
          address.country = :europe
        end
        puts "Address #{address.id} updated"
        address.save!(validate: false)
      end
      address = order.shipping_address
      if address
        if address.country == :CN
          address.country = :china
        else
          address.country = :europe
        end
        puts "Address #{address.id} updated"
        address.save!(validate: false)
      end
    end

  end

  def self.down
  end
end
