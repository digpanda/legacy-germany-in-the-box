# required
WxPay.appid = ENV['wechat_username_mobile']
WxPay.key = ENV['wechat_pay_key']
WxPay.mch_id = ENV['wechat_mch_id']
WxPay.debug_mode = true # default is `true`

# wechat_username: wx84debd17520da2a3
# wechat_password: 07e1c9e9e850d3e6b8e0b8a83a9ac0e9

# wechat_username_mobile: wxfde44fe60674ba13
# wechat_password_mobile: ba4909d26bb13a3dcb80e3942b804631

# cert, see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
# using PCKS12
pkcs12_filepath = File.join(Rails.root, 'vendor', 'certificates/apiclient_cert.p12')
pkcs12_password = WxPay.mch_id
WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), pkcs12_password)

# if you want to use `generate_authorize_req` and `authenticate`
WxPay.appsecret = 'YOUR_SECRET' # not essential for now

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = { timeout: 30, open_timeout: 50 }
