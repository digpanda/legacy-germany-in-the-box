require 'rails_helper'
require 'border_guru/payloads/label_api'

describe BorderGuru::Payloads::LabelApi do

  before do
    @payload = BorderGuru::Payloads::LabelApi.new(
        border_guru_shipment_id: '061039676'
    )
  end

  it 'adds the shipment id to payload' do
    assert_equal '061039676', @payload.to_h[:shipmentIdentifier]
  end

end

