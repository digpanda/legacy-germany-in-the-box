require 'rails_helper'
require 'border_guru/payloads/shipping_api'

describe BorderGuru::Payloads::ShippingApi do

  before do
    @customer = create(:customer, :with_orders)
    @order = @customer.orders.first
    @shop = @order.shop
    @country_of_destination = ISO3166::Country.new('CN')
    @payload = BorderGuru::Payloads::ShippingApi.new(
        order: @order,
        shop: @shop,
        country_of_destination: @country_of_destination,
        currency: 'EUR'
    )
  end

  it 'registers line items from order products' do
    line_items = @payload.to_h[:lineItems]
    assert_instance_of Array, line_items
  end

  it 'adds products attributes to line items' do
    line_item = @payload.to_h[:lineItems].first

    {
        shortDescription: 'Product 1',
        price: 11,
        weight: 0.1,
        quantity: 1,
        countryOfManufacture: 'DE',
        category: 'test'
    }.each do |key, expected|
      assert_equal expected, line_item[key]
    end
  end

  it 'adds order value to the payload' do
    assert_equal BigDecimal.new(2 * 1 * 11), @payload.to_h[:subtotal]
  end

  it 'adds order weight to the payload' do
    assert_equal 2 * 1 * 0.1, @payload.to_h[:totalWeight]
    assert_equal 'kg', @payload.to_h[:totalWeightScale]
  end

  it "adds shop's country of dispatcher to payload" do
    assert_equal 'DE', @payload.to_h[:countryOfOrigin]
  end

  it "adds shop's currency to payload" do
    assert_equal 'EUR', @payload.to_h[:currency]
  end

  it 'adds country of destination to payload' do
    assert_equal 'CN', @payload.to_h[:countryOfDestination]
  end

  it "adds the shop's name to payload" do
    assert_equal 'Seppls Lederhosenladen', @payload.to_h[:storeName]
  end

  it 'adds a previously obtained quote ID to payload' do
    assert_equal 'BG-DE-CN-01234567898', @payload.to_h[:quoteIdentifier]
  end

  it 'adds the proper shipping address' do
    shipping_address = @payload.to_h[:shippingAddress].first
    {
        firstName:          '薇',
        lastName:           '李',
        streetName:         '和平区 华江里',
        additionalInfo:     '309室',
        postcode:           '300222',
        city:               '天津 天津',
        country:            'China',
        telephone:          '+86123456',
        email:              @customer.email,
        countryCode:        'CN'
    }.each do |key, expected|
      assert_equal expected, shipping_address[key]
    end
  end

  it 'adds the proper billing address' do
    billing_address = @payload.to_h[:billingAddress].first
    {
        firstName:          '薇',
        lastName:           '李',
        streetName:         '和平区 华江里',
        additionalInfo:     '309室',
        postcode:           '300222',
        city:               '天津 天津',
        country:            'China',
        telephone:          '+86123456',
        email:              @customer.email,
        countryCode:        'CN'
    }.each do |key, expected|
      assert_equal expected, billing_address[key]
    end
  end

end

