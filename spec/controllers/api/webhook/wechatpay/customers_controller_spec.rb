describe Api::Webhook::Wechatpay::CustomersController, type: :controller do

  render_views # jbuilder requirement

  describe '#create' do

    let(:order_payment) { FactoryGirl.create(:order_payment, :with_scheduled, :with_wechatpay) }
    let(:order) { order_payment.order }

    scenario 'confirm a payment' do

      post :create, wechatpay_valid_success_params(order).to_xml(root: :xml, skip_types: true)
      order_payment.reload
      expect_json(success: true)
      expect(order_payment.status).to eql(:success)

    end

    scenario 'refuse a payment with wrong format' do

      post :create, random: true
      expect_json(success: false)

    end

    scenario 'refuse a payment with wrong params' do

      post :create, { random: true }.to_xml(root: :xml, skip_types: true)
      expect_json(success: false)

    end

    scenario 'refuse a payment with failed process' do

      post :create, wechatpay_valid_failed_params(order).to_xml(root: :xml, skip_types: true)
      order_payment.reload
      expect_json(success: true)
      expect(order_payment.status).to eql(:failed)

    end

  end

end

# NOTE : we are not 100% sure if those data are relevant to the real ones
# please use #notifs to check it out later on.
def wechatpay_valid_success_params(order)
  {
    'return_code'    => 'SUCCESS',
    'return_msg'     => 'OK',
    'appid'          => 'wxfde44fe60674ba13',
    'mch_id'         => '1354063202',
    'nonce_str'      => 'cvTr8zN4EU4RTvFt',
    'sign'           => '5F7FB422CC25A8B8287EA8AF99E8D192',
    'result_code'    => 'SUCCESS',
    'prepay_id'      => 'wx201703161727381d0112c4620476236953',
    'trade_type'     => 'JSAPI',
    'out_trade_no'   => "#{order_payment.id}",
    'transaction_id' => 'RANDOM-TRANSACTION',
    'total_fee'      => "#{order.end_price.in_euro.to_yuan}",
    'buyer_email'    => 'douyufua@alitest.com'
  }
end

def wechatpay_valid_failed_params(order)
  {
    'return_code'    => 'FAIL',
    'return_msg'     => 'OK',
    'appid'          => 'wxfde44fe60674ba13',
    'mch_id'         => '1354063202',
    'nonce_str'      => 'cvTr8zN4EU4RTvFt',
    'sign'           => '5F7FB422CC25A8B8287EA8AF99E8D192',
    'result_code'    => 'SUCCESS',
    'prepay_id'      => 'wx201703161727381d0112c4620476236953',
    'trade_type'     => 'JSAPI',
    'out_trade_no'   => "#{order_payment.id}",
    'transaction_id' => 'RANDOM-TRANSACTION',
    'total_fee'      => "#{order.end_price.in_euro.to_yuan}",
    'buyer_email'    => 'douyufua@alitest.com',
  }
end
