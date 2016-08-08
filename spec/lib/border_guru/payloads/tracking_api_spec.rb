require 'rails_helper'
require 'border_guru/payloads/tracking_api'

describe BorderGuru::Payloads::TrackingApi do

  before do
    @customer = create(:customer, :with_orders)
    @order =  @customer.orders.first
    @shop = @order.shop
    @payload = BorderGuru::Payloads::TrackingApi.new(
    dispatcher: @shop.sender_address,
    order: @order
    )
  end

  it 'adds the merchant order id to payload' do
    assert @payload.to_h[:merchantOrderId]
  end

  it 'adds the dispatchers location to payload' do
    assert_equal "#{@shop.billing_address.city}, Germany", @payload.to_h[:trackingLocation]
  end


  it "adds the order's weight" do
    assert_equal @order.total_weight, @payload.to_h[:trackingWeight]
  end

  it "adds the order's weight scale" do
    assert_equal 'kg', @payload.to_h[:trackingWeightScale]
  end

end
