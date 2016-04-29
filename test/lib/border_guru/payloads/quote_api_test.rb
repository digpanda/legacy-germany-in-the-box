require 'test_helper'
require 'border_guru/payloads/quote_api'

class BorderGuru::Payloads::QuoteApiTest < ActiveSupport::TestCase

  setup do
    @shop = create :shop
    @country_of_destination = ISO3166::Country.new('CN')
    @cart = create :cart
    @product = create :product
    @cart.add @product, 2
  end

  test 'registers line items from cart products' do
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

  test 'adds cart value to the payload' do
    assert_equal 2.46, payload.to_h[:subtotal]
  end

  test 'adds cart weight to the payload' do
    assert_equal 1.5 * 2, payload.to_h[:totalWeight]
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

  private

  def payload
    BorderGuru::Payloads::QuoteApi.new(
      cart: @cart,
      shop: @shop,
      country_of_destination: @country_of_destination,
      currency: 'EUR'
    )
  end

end

