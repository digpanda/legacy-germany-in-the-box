class Guest::WechatpayController < ApplicationController

  def show

    # required fields
    params = {
      body: 'test',
      out_trade_no: 'jlkkkmlkjtest003',
      total_fee: 1,
      spbill_create_ip: '127.0.0.1',
      notify_url: 'http://making.dev/notify',
      trade_type: 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
      openid: 'olcTSw3JroHuObs3V7r-f5XDy-vA' # required when trade_type is `JSAPI`
    }

    signature = {
      appid: WxPay.appid,
      mch_id: WxPay.mch_id,
      device_info: 1000,
      body: 'test',
      nonce_str: SecureRandom.uuid.tr('-', '')
    }
    # appid：	wxd930ea5d5a258f4f
    # mch_id：	10000100
    # device_info：	1000
    # body：	test
    # nonce_str：	ibuaiVcKdpRxkhJA

    params[:sign] = WxPay::Sign.generate(signature)


    # wechat_username: wx84debd17520da2a3
    # wechat_password: 07e1c9e9e850d3e6b8e0b8a83a9ac0e9
    binding.pry

    # request = WxPay::Service.generate_js_pay_req(params)
    result = WxPay::Service.invoke_unifiedorder(params)

  end

  private

end
