require 'test_helper'
require 'border_guru/payloads/shipping_api'

class BorderGuru::Payloads::ShippingApiTest < ActiveSupport::TestCase

  setup do
    @shop = create :shop
    @country_of_destination = ISO3166::Country.new('CN')
    @order = create :order
  end

  test 'registers line items from order products' do
    line_items = payload.to_h[:lineItems]
    assert_instance_of Array, line_items
  end

  test 'adds products attributes to line items' do
    line_item = payload.to_h[:lineItems].first
    {
      sku: 'MyBrand-123456',
      shortDescription: 'My Product',
      price: 1.23,
      weight: 1.5,
      # see setup block
      quantity: 2,
      countryOfManufacture: 'DE',
      category: 'test'
    }.each do |key, expected|
      assert_equal expected, line_item[key]
    end
  end

  test 'adds order value to the payload' do
    # two different order line items with an ordered
    # quantity of 2, each
    assert_equal 2 * 2 * 1.23, payload.to_h[:subtotal]
  end

  test 'adds order weight to the payload' do
    # two different order line items with an ordered
    # quantity of 2, each
    assert_equal 2 * 2 * 1.5, payload.to_h[:totalWeight]
    assert_equal 'kg', payload.to_h[:totalWeightScale]
  end

  test "adds shop's country of dispatcher to payload" do
    assert_equal 'DE', payload.to_h[:countryOfOrigin]
  end

  test "adds shop's currency to payload" do
    assert_equal 'EUR', payload.to_h[:currency]
  end

  test 'adds country of destination to payload' do
    assert_equal 'CN', payload.to_h[:countryOfDestination]
  end

  test "adds the shop's order id to payload" do
    assert_equal 'Order0123456', payload.to_h[:merchantOrderId]
  end

  test "adds the shop's name to payload" do
    assert_equal 'Seppls Lederhosenladen', payload.to_h[:storeName]
  end

  test 'adds a previously obtained quote ID to payload' do
    assert_equal 'BG-DE-CN-01234567898', payload.to_h[:quoteIdentifier]
  end

  test 'adds the proper shipping address' do
    shipping_address = payload.to_h[:shippingAddress].first
    {
      firstName:    'Daniel',
      lastName:     'Beckenbauer',
      streetName:   '54a Reeperbahn',
      additionalInfo:      'Zi. 2046',
      postcode:     '22222',
      city:          'Hamburg',
      country:       'Germany',
      telephone:     '+49123456',
      email:         'foo@bar.com',
      countryCode:  'DE'
    }.each do |key, expected|
      assert_equal expected, shipping_address[key]
    end
  end

  test 'adds the proper billing address' do
    billing_address = payload.to_h[:billingAddress].first
    {
      # only check if the address is different from the
      # shipping address, the rest of the code is tested
      # through the shipping address test.
      firstName:    'Daniela',
      lastName:     'Beckenbauer',
    }.each do |key, expected|
      assert_equal expected, billing_address[key]
    end
  end


  private

  def payload
    BorderGuru::Payloads::ShippingApi.new(
      order: @order,
      shop: @shop,
      country_of_destination: @country_of_destination,
      currency: 'EUR'
    )
  end

end

