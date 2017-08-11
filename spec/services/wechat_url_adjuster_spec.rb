describe WechatUrlAdjuster  do

  context '#adjusted_url' do

    # super dummy test
    it 'adjust the URL correctly' do

      raw_url = 'http://test.com/waddup/?not_much=yes&and_you=no'
      adjuster = WechatUrlAdjuster.new(raw_url)
      expect(adjuster.adjusted_url).to eq('https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9b33e28c238fd3fd&redirect_uri=http%3A%2F%2Ftest.com%2Fwaddup%2F%3Fnot_much%3Dyes%26and_you%3Dno&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect')

    end

  end

end
