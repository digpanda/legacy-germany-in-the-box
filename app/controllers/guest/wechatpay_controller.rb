class Guest::WechatpayController < ApplicationController

  def show

    # required fields
    params = {
      body: 'test',
      out_trade_no: 'test003',
      total_fee: 1,
      spbill_create_ip: '127.0.0.1',
      notify_url: 'http://making.dev/notify',
      trade_type: 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
      openid: 'OPENID' # required when trade_type is `JSAPI`
    }

    result = WxPay::Service.invoke_unifiedorder
    binding.pry

  end

  private

end
