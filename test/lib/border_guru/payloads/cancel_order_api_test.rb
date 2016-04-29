require 'test_helper'
require 'border_guru/payloads/cancel_order_api'

class BorderGuru::Payloads::CancelOrderApiTest < ActiveSupport::TestCase

  test 'adds the shipment id to payload' do
    assert_equal '061039676', payload.to_h[:shipmentIdentifier]
  end

  private

  def payload
    BorderGuru::Payloads::CancelOrderApi.new(
      border_guru_shipment_id: '061039676'
    )
  end

end

