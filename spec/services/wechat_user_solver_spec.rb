describe WechatUserSolver  do

    let(:wechat_data) do {
        provider: valid_wechat_omniauth_callback.provider,
        unionid: valid_wechat_omniauth_callback.info.unionid,
        openid: valid_wechat_omniauth_callback.info.openid,
        nickname: valid_wechat_omniauth_callback.info.nickname,
        avatar: valid_wechat_omniauth_callback.info.headimgurl,
        sex: valid_wechat_omniauth_callback.info.sex,
      }
    end

  context "#resolve!" do

    subject(:wechat_user_solver) { WechatUserSolver.new(wechat_data) }

    it "creates and return a new customer" do

      resolved = wechat_user_solver.resolve!
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:customer]).to be_a(User)

    end

    let!(:current_user) { FactoryGirl.create(:customer, provider: "wechat", wechat_unionid: "whatever-unionid") }

    it "use an existing customer and return it" do

      resolved = wechat_user_solver.resolve!
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:customer]).to be_a(User)

      # is it the same user ?
      expect(resolved.data[:customer].id).to eq(current_user.id)

    end

  end

end
