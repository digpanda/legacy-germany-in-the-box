require 'rails_helper'
require 'border_guru/payloads/tracking_api'

describe BorderGuru::Payloads::TrackingApi do

  before do
    @payload = BorderGuru::Payloads::TrackingApi.new(
        dispatcher: create(:shop).sender_address,
        order: create(:order)
    )
  end

  it 'adds the merchant order id to payload' do
    assert @payload.to_h[:merchantOrderId]
  end

  it 'adds the dispatchers location to payload' do
    assert_equal 'Vaterstetten, Germany', @payload.to_h[:trackingLocation]
  end


  it "adds the order's weight" do
    assert_equal 0.2, @payload.to_h[:trackingWeight]
  end

  it "adds the order's weight scale" do
    assert_equal 'kg', @payload.to_h[:trackingWeightScale]
  end

end

