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
        shortDescription: @shop.products.first.name,
        price: @shop.products.first.skus.first.price.to_i,
        weight: @shop.products.first.skus.first.weight,
        quantity: @shop.products.first.skus.first.quantity,
        countryOfManufacture: @shop.sender_address.country.alpha2,
        category: 'test'
    }.each do |key, expected|
      assert_equal expected, line_item[key]
    end
  end

  it 'adds cart value to the payload' do
    assert_equal BigDecimal.new(22), @payload.to_h[:subtotal]
  end

  it 'adds cart weight to the payload' do
    assert_equal 0.1 * 2, @payload.to_h[:totalWeight]
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

end

