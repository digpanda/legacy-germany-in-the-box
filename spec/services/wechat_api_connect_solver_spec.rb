describe WechatApiConnectSolver  do

  context '#resolve!' do

    subject(:wechat_api_connect_solver) { WechatApiConnectSolver.new("fake-code") }

    it 'succeed and create a new user' do

      allow_any_instance_of(WechatApiConnectSolver).to receive(:access_token_gateway).and_return({
        "openid" => "test-open-id",
        "unionid" => "test-union-id",
        "access_token" => "test-access-token"
      })

      allow_any_instance_of(WechatApiConnectSolver).to receive(:user_info_gateway).and_return({
        "unionid" => "test-union-id",
        "openid" => "test-open-id",
        "nickname" => "test-nickname",
        "headimgurl" => "http://image.com",
        "sex" => "f"
      })

      resolved = wechat_api_connect_solver.resolve!
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:customer]).to be_a(User)

    end

    let!(:current_user) { FactoryGirl.create(:customer, provider: "wechat", wechat_unionid: "whatever-unionid") }

    it 'succeeds and retrieve an old user' do

      allow_any_instance_of(WechatApiConnectSolver).to receive(:access_token_gateway).and_return({
        "openid" => "test-open-id",
        "unionid" => "whatever-unionid",
        "access_token" => "test-access-token"
      })

      allow_any_instance_of(WechatApiConnectSolver).to receive(:user_info_gateway).and_return({
        "openid" => "test-open-id",
        "unionid" => "whatever-unionid",
        "nickname" => "test-nickname",
        "headimgurl" => "http://image.com",
        "sex" => "f"
      })

      resolved = wechat_api_connect_solver.resolve!
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:customer]).to be_a(User)

      # is it the same user ?
      expect(resolved.data[:customer].id).to eq(current_user.id)
    end

    it 'fails creating the user with those infos' do

      allow_any_instance_of(WechatApiConnectSolver).to receive(:access_token_gateway).and_return({
        "openid" => nil,
        "unionid" => nil,
        "access_token" => "test-access-token"
      })

      allow_any_instance_of(WechatApiConnectSolver).to receive(:user_info_gateway).and_return({
        "unionid" => nil,
        "openid" => nil,
        "nickname" => "test-nickname",
        "headimgurl" => "http://image.com",
        "sex" => "f"
      })

      resolved = wechat_api_connect_solver.resolve!
      expect(resolved.success?).to eq(false)

    end

    it 'throws an error from the API' do

      allow_any_instance_of(WechatApiConnectSolver).to receive(:access_token_gateway).and_return({
        "errcode" => "289"
      })

      resolved = wechat_api_connect_solver.resolve!
      expect(resolved.success?).to eq(false)

    end

  end

end
