require 'cgi'

# Get notifications from Alipay when a transaction has been done
class Api::Webhook::Alipay::CustomersController < Api::ApplicationController

  skip_before_filter :verify_authenticity_token

  def new
    result = Hash.from_xml(request.body.read)["xml"]

    if WxPay::Sign.verify?(result)
      binding.pry
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      binding.pry
      render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

end
