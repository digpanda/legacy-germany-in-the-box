require 'rails_helper'
require 'border_guru/payloads/shipping_api'

describe BorderGuru::Payloads::ShippingApi do

  # before do
  #   @customer = create(:customer, :with_orders)
  #   @order = @customer.orders.first
  #   @shop = @order.shop
  #   @country_of_destination = ISO3166::Country.new('CN')
  #   @payload = BorderGuru::Payloads::ShippingApi.new(
  #       order: @order,
  #       shop: @shop,
  #       country_of_destination: @country_of_destination,
  #       currency: 'EUR'
  #   )
  # end
  #
  # it 'registers line items from order products' do
  #   line_items = @payload.to_h[:lineItems]
  #   assert_instance_of Array, line_items
  # end
  #
  # it 'adds products attributes to line items' do
  #   line_item = @payload.to_h[:lineItems].first
  #   {
  #     shortDescription: @order.order_items.first.product.name,
  #     price: @order.order_items.first.sku.price,
  #     weight: @order.order_items.first.sku.weight,
  #     quantity: @order.order_items.first.quantity,
  #     countryOfManufacture: @shop.sender_address.country.alpha2,
  #     category: 'test'
  #   }.each do |key, expected|
  #     assert_equal expected, line_item[key]
  #   end
  # end
  #
  # it 'adds order value to the payload' do
  #   assert_equal @order.total_value, @payload.to_h[:subtotal]
  # end
  #
  # it 'adds order weight to the payload' do
  #   assert_equal  @order.total_weight, @payload.to_h[:totalWeight]
  #   assert_equal 'kg', @payload.to_h[:totalWeightScale]
  # end
  #
  #
  # it "adds shop's country of dispatcher to payload" do
  #   assert_equal 'DE', @payload.to_h[:countryOfOrigin]
  # end
  #
  # it "adds shop's currency to payload" do
  #   assert_equal 'EUR', @payload.to_h[:currency]
  # end
  #
  # it 'adds country of destination to payload' do
  #   assert_equal 'CN', @payload.to_h[:countryOfDestination]
  # end
  #
  # it "adds the shop's name to payload" do
  #   assert_equal @shop.name, @payload.to_h[:storeName]
  # end
  #
  # it 'adds a previously obtained quote ID to payload' do
  #   assert_equal 'BG-DE-CN-01234567898', @payload.to_h[:quoteIdentifier]
  # end

end
