require 'rails_helper'
require 'border_guru/payloads/shipping_api'

describe BorderGuru::Payloads::ShippingApi do

  before do
    @shop = create :shop
    @country_of_destination = ISO3166::Country.new('CN')
    @order = create :order
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
    # two different order line items with an ordered
    # quantity of 2, each
    assert_equal BigDecimal.new(1 * 1 * 11), @payload.to_h[:subtotal]
  end
end

