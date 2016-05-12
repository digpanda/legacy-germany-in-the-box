require 'rails_helper'
require 'border_guru/payloads/quote_api'

describe BorderGuru::Payloads::QuoteApi do

  before do
    @shop = create :shop
    @country_of_destination = ISO3166::Country.new('CN')
    @cart = create :cart
    @product = @shop.products.first
    @cart.add @product.skus.first, 2

    @payload = BorderGuru::Payloads::QuoteApi.new(
        cart: @cart,
        shop: @shop,
        country_of_destination: @country_of_destination,
        currency: 'EUR'
    )
  end

  it 'registers line items from cart products' do
    line_items = @payload.to_h[:lineItems]
    assert_instance_of Array, line_items
  end

  it 'adds products attributes to line items' do
    line_item = @payload.to_h[:lineItems].first
    {
        shortDescription: 'Product 1',
        price: 2.46,
        weight: 1,
        # see setup block
        quantity: 2,
        countryOfManufacture: 'DE',
        category: 'L2-276'
    }.each do |key, expected|
      assert_equal expected, line_item[key]
    end
  end

  it 'adds cart value to the payload' do
    assert_equal 4.92, @payload.to_h[:subtotal]
  end

end

