require 'test_helper'
require 'border_guru/payloads/tracking_api'

class BorderGuru::Payloads::TrackingApiTest < ActiveSupport::TestCase

  test 'adds the merchant order id to payload' do
    assert_equal 'Order0123456', payload.to_h[:merchantOrderId]
  end

  test 'adds the dispatchers location to payload' do
    assert_equal 'Hamburg, Germany', payload.to_h[:trackingLocation]
  end

  test "adds the order's weight" do
    assert_equal 6.0, payload.to_h[:trackingWeight]
  end

  test "adds the order's weight scale" do
    assert_equal 'kg', payload.to_h[:trackingWeightScale]
  end

  private

  def payload
    BorderGuru::Payloads::TrackingApi.new(
      order: create(:order),
      dispatcher: create(:shop).dispatcher
    )
  end

end

