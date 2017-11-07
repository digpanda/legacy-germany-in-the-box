class NewAddressFormat < Mongoid::Migration
  def self.up
    loop_it Shop, Shop.all.map(&:addresses).flatten.compact
    loop_it User, User.all.map(&:addresses).flatten.compact
    loop_it Order, Order.all.map(&:billing_address).flatten.compact
    loop_it Order, Order.all.map(&:shipping_address).flatten.compact
  end

  def self.down
  end

  def self.loop_it(class_name, resources)
    puts "Processing #{class_name}"
    resources.each do |address|
      address.full_address = "#{address.attributes['province']}#{address.attributes['city']}#{address.attributes['district']}#{address.attributes['street']}#{address.attributes['number']}#{address.attributes['additional']}, #{address.attributes['zip']}"
      address.save!(validate: false)
      puts "New Address `#{address.id}` is `#{address.full_address}`"
    end
  end
end
