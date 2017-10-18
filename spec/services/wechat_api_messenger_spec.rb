describe WechatApiMessenger do

  context '#text' do

    it 'send a text without problem' do

      allow_any_instance_of(described_class).to receive(:access_token_gateway).and_return(
        BaseService.new.return_with(:success, access_token: 'random-token')
      )

      allow_any_instance_of(described_class).to receive(:gateway).and_return(
        'random' => 'random'
      )

      allow_any_instance_of(described_class).to receive(:wechat_api_media).and_return(
        BaseService.new.return_with(:success, media_id: 'fake-media-id')
      )

      expect { WechatApiMessenger.new(openid: 'openid').image('image').send }.not_to raise_error

    end

  end

  context '#image' do

    it 'send an image without problem' do

      allow_any_instance_of(described_class).to receive(:access_token_gateway).and_return(
        BaseService.new.return_with(:success, access_token: 'random-token')
      )

      allow_any_instance_of(described_class).to receive(:gateway).and_return(
        'random' => 'random'
      )

      expect { WechatApiMessenger.new(openid: 'openid').text('text').send }.not_to raise_error

    end

  end

end
