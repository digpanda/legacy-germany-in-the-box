require 'rails_helper'
require 'border_guru/payloads/cancel_order_api'

describe BorderGuru::Payloads::CancelOrderApi do

  before do
    @payload = BorderGuru::Payloads::CancelOrderApi.new(
        border_guru_shipment_id: '061039676'
    )
  end

  it 'adds the shipment id to payload' do
    assert_equal '061039676', @payload.to_h[:shipmentIdentifier]
  end

end

