module Helpers
  module Devise
    module_function

    def valid_wechat_omniauth_callback
      OmniAuth::AuthHash.new(
        'provider' => 'wechat',
        'uid' => 'fake-uid',
        'info' =>
        {
          'nickname' => 'Laurent Schaffner',
          'sex' => 1,
          'province' => '',
          'city' => '',
          'country' => 'FR',
          'headimgurl' => 'http://wx.qlogo.cn/mmopen/5jeib6VAWzVGV2yDABQ6U18tXiatPqhibnIuYibtp9mxEuzGg4KPaZbRaicayacQW1xbKurmlGMQv9XMG8rYmLHRAVbYfLP6Vkchq/0',
          'unionid' => 'whatever-unionid'
        },
        'credentials' =>
        {
          'token' => 'QFnrNZslKBEr7OHpYBVRX0ozoJNRBS71waSRH16Q8wAZGKZQIXxlayC9apCmB7GgWIIUZEHnLntM7W77c-4kx1QI_QQd1-Y_AHThj0tz80g',
          'refresh_token' => 'k_qTIBxqSs7RNAI0UyBm-l0vR7pZMKQir7vcxBy4QthBPA1o-E-OtTbY5hhySraxazZftrHfgOwSaJuOCo8l5dy7Ls5rKXUr9O_po0OlyjM',
          'expires_at' => 1480443671,
          'expires' => true
        },
          'extra' =>
          {
            'raw_info' =>
            {
              'openid' => 'whatever-openid',
              'nickname' => 'Laurent Schaffner',
              'sex' => 1,
              'language' => 'en',
              'city' => '',
              'province' => '',
              'country' => 'FR',
              'headimgurl' => 'http://wx.qlogo.cn/mmopen/5jeib6VAWzVGV2yDABQ6U18tXiatPqhibnIuYibtp9mxEuzGg4KPaZbRaicayacQW1xbKurmlGMQv9XMG8rYmLHRAVbYfLP6Vkchq/0',
              'privilege' => [],
              'unionid' => 'whatever-unionid'
            }
          }
        )
    end

    def login_admin(admin)
      @request.env['devise.mapping'] = ::Devise.mappings[:admin]
      sign_in admin # Using factory girl as an example
    end

    def login_shopkeeper(shopkeeper)
      @request.env['devise.mapping'] = ::Devise.mappings[:shopkeeper]
      sign_in shopkeeper
    end

    def login_customer(customer)
      @request.env['devise.mapping'] = ::Devise.mappings[:user]
      sign_in customer
      #allow(controller).to receive(:current_user) { customer }
      #allow(request.env['warden']).to receive(:authenticate!).and_return(customer)
    end
  end
end
