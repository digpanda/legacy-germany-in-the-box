describe WechatUserSolver  do

  VALID_OMNIAUTH_CALLBACK = OmniAuth::AuthHash.new({
    "provider"=>"wechat",
     "uid"=>"fake-uid",
     "info"=>
      {"nickname"=>"Laurent Schaffner",
       "sex"=>1,
       "province"=>"",
       "city"=>"",
       "country"=>"FR",
       "headimgurl"=>"http://wx.qlogo.cn/mmopen/5jeib6VAWzVGV2yDABQ6U18tXiatPqhibnIuYibtp9mxEuzGg4KPaZbRaicayacQW1xbKurmlGMQv9XMG8rYmLHRAVbYfLP6Vkchq/0",
       "unionid"=>"whatever-unionid"},
     "credentials"=>
      {"token"=>"QFnrNZslKBEr7OHpYBVRX0ozoJNRBS71waSRH16Q8wAZGKZQIXxlayC9apCmB7GgWIIUZEHnLntM7W77c-4kx1QI_QQd1-Y_AHThj0tz80g",
       "refresh_token"=>"k_qTIBxqSs7RNAI0UyBm-l0vR7pZMKQir7vcxBy4QthBPA1o-E-OtTbY5hhySraxazZftrHfgOwSaJuOCo8l5dy7Ls5rKXUr9O_po0OlyjM",
       "expires_at"=>1480443671,
       "expires"=>true},
     "extra"=>
      {"raw_info"=>
        {"openid"=>"whatever-openid",
         "nickname"=>"Laurent Schaffner",
         "sex"=>1,
         "language"=>"en",
         "city"=>"",
         "province"=>"",
         "country"=>"FR",
         "headimgurl"=>"http://wx.qlogo.cn/mmopen/5jeib6VAWzVGV2yDABQ6U18tXiatPqhibnIuYibtp9mxEuzGg4KPaZbRaicayacQW1xbKurmlGMQv9XMG8rYmLHRAVbYfLP6Vkchq/0",
         "privilege"=>[],
         "unionid"=>"whatever-unionid"}}
    })

  context "#resolve!" do

    subject(:wechat_connect) { WechatUserSolver.new(VALID_OMNIAUTH_CALLBACK) }

    it "creates and return a new customer" do

      resolved = wechat_connect.resolve!
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:customer]).to be_a(User)

    end

    let!(:current_user) { FactoryGirl.create(:customer, provider: "wechat", uid: "fake-uid") }

    it "use an existing customer and return it" do

      resolved = wechat_connect.resolve!
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:customer]).to be_a(User)

      # is it the same user ?
      expect(resolved.data[:customer].id).to eq(current_user.id)

    end

  end

end
