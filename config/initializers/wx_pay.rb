# # required
# WxPay.appid = 'wxfde44fe60674ba13'
# WxPay.key = 'ba4909d26bb13a3dcb80e3942b804631'
# WxPay.mch_id = '1354063202'
# WxPay.debug_mode = true # default is `true`
#
# # wechat_username_mobile: wxfde44fe60674ba13
# # wechat_password_mobile: ba4909d26bb13a3dcb80e3942b804631
#
# # cert, see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
# # using PCKS12
# pkcs12_filepath = File.join(Rails.root, 'vendor', 'certificates/apiclient_cert.p12')
# pkcs12_password = '473246'
# binding.pry
# WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), pkcs12_password)
#
# # if you want to use `generate_authorize_req` and `authenticate`
# WxPay.appsecret = 'YOUR_SECRET' # not essential for now
#
# # optional - configurations for RestClient timeout, etc.
# WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}
