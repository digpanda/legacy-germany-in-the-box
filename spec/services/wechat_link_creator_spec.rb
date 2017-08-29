describe WechatLinkCreator  do

  context '#with_referrer' do

    let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }
    let(:link) { FactoryGirl.create(:link) }

    # super dummy test
    it 'generates a correct end link with referrer' do

      creator = WechatLinkCreator.new(link)
      end_link = creator.with_referrer(referrer)
      expect(end_link).to eq("https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9b33e28c238fd3fd&redirect_uri=https%3A%2F%2Flocal.dev%3A3333%2Fguest%2Flinks%2F#{link.id}%3Freference_id%3D#{referrer.reference_id}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect")

    end

  end

end
