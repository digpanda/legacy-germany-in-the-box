class Guest::WechatpayController < ApplicationController

  def show

    # required fields
    params = {
      body: 'test',
      out_trade_no: 'jlkkkmlkjtest003',
      total_fee: 1,
      spbill_create_ip: '127.0.0.1',
      notify_url: new_api_webhook_wechatpay_customer_path,
      trade_type: 'JSAPI', # 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
      openid: 'oKhjVvuA9bhRwpsvDqAHRsCAgxUU'
    }

    # wechat_username: wx84debd17520da2a3
    # wechat_password: 07e1c9e9e850d3e6b8e0b8a83a9ac0e9

    # request = WxPay::Service.generate_js_pay_req(params)
    raw_result = WxPay::Service.invoke_unifiedorder(params)
    result = raw_result[:raw]["xml"]

    if result["result_code"] != "SUCCESS"
      # There were a problem
      binding.pry
    end

    # required fields
    params = {
      prepayid: result["prepay_id"],
      noncestr: result["nonce_str"]
    }

    result = WxPay::Service.generate_js_pay_req params

    binding.pry

  end

  private

end
