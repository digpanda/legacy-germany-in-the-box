require 'test_helper'
require 'border_guru/payloads/label_api'

class BorderGuru::Payloads::LabelApiTest < ActiveSupport::TestCase

  test 'adds the shipment id to payload' do
    assert_equal '061039676', payload.to_h[:shipmentIdentifier]
  end

  private

  def payload
    BorderGuru::Payloads::LabelApi.new(
      border_guru_shipment_id: '061039676'
    )
  end

end

