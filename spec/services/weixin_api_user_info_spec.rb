describe WeixinApiUserInfo do

  context '#resolve!' do

    subject(:subject) { described_class.new('random-openid') }

    it 'returns the user informations' do

      allow_any_instance_of(described_class).to receive(:access_token_gateway).and_return(
        BaseService.new.return_with(:success, access_token: 'random token')
      )

      allow_any_instance_of(described_class).to receive(:user_info_gateway).and_return('info': 'some stuff')

      resolved = subject.resolve!
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:user_info]).to eq('info': 'some stuff')

    end

    it 'fails resolving the user_info' do

      allow_any_instance_of(described_class).to receive(:access_token_gateway).and_return(
        BaseService.new.return_with(:success, access_token: 'random token')
      )

      allow_any_instance_of(described_class).to receive(:user_info_gateway).and_return(
        'errcode' => '1',
        'errmsg' => 'random error'
      )

      resolved = subject.resolve!
      expect(resolved.success?).to eq(false)
      expect(resolved.error).to eq('random error')

    end

  end

end
