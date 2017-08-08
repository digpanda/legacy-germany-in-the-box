describe Api::Webhook::Alipay::CustomersController, type: :controller do

  render_views # jbuilder requirement

  describe '#create' do

    let(:order_payment) { FactoryGirl.create(:order_payment, :with_scheduled, :with_alipay) }
    let(:order) { order_payment.order }

    scenario 'confirm a payment' do

      post :create, alipay_valid_success_params(order)
      order_payment.reload
      expect_json(success: true)
      expect(order_payment.status).to eql(:success)

    end

    scenario 'refuse a payment with wrong params' do

      post :create, random: true
      expect_json(success: false)

    end

    scenario 'refuse a payment with failed process' do

      post :create, alipay_valid_failed_params(order)
      order_payment.reload
      expect_json(success: true)
      expect(order_payment.status).to eql(:failed)

    end

  end

end

def alipay_valid_success_params(order)
  {
    'discount'            => '0.00',
    'payment_type'        => '1',
    'subject'             => "Order #{order.id}",
    'trade_no'            => '2017030521001004840200342628',
    'buyer_email'         => 'douyufua@alitest.com',
    'gmt_create'          => '2017-03-05 18:06:49',
    'notify_type'         => 'trade_status_sync',
    'quantity'            => '1',
    'out_trade_no'        => "#{order.id}",
    'seller_id'           => '2088101122136241',
    'notify_time'         => '2017-03-05 18:21:11',
    'trade_status'        => 'TRADE_SUCCESS', # TRADE_FINISHED ?
    'is_total_fee_adjust' => 'N',
    'total_fee'           => "#{order.end_price.in_euro.to_yuan}",
    'gmt_payment'         => '2017-03-05 18:17:17',
    'seller_email'        => 'overseas_kgtest@163.com',
    'price'               => "#{order.end_price.in_euro.to_yuan}",
    'buyer_id'            => '2088102140176848',
    'notify_id'           => '39863b44e9bf2e9877a57ef5451a717mhe',
    'use_coupon'          => 'N',
    'sign_type'           => 'MD5',
    'sign'                => 'c8215a718439aec25cf8051730bf459a'
  }
end

def alipay_valid_failed_params(order)
  {
    'discount'            => '0.00',
    'payment_type'        => '1',
    'subject'             => "Order #{order.id}",
    'trade_no'            => '2017030521001004840200342628',
    'buyer_email'         => 'douyufua@alitest.com',
    'gmt_create'          => '2017-03-05 18:06:49',
    'notify_type'         => 'trade_status_sync',
    'quantity'            => '1',
    'out_trade_no'        => "#{order.id}",
    'seller_id'           => '2088101122136241',
    'notify_time'         => '2017-03-05 18:21:11',
    'trade_status'        => 'TRADE_FAILURE',
    'is_total_fee_adjust' => 'N',
    'total_fee'           => '793.36',
    'gmt_payment'         => '2017-03-05 18:17:17',
    'seller_email'        => 'overseas_kgtest@163.com',
    'price'               => "#{order.end_price.in_euro.to_yuan}",
    'buyer_id'            => '2088102140176848',
    'notify_id'           => '39863b44e9bf2e9877a57ef5451a717mhe',
    'use_coupon'          => 'N',
    'sign_type'           => 'MD5'
  }
end
