describe WeixinApiAccessToken  do

  context '#resolve' do

    subject(:subject) { described_class.new }

    it 'returns an access token' do

      allow_any_instance_of(described_class).to receive(:gateway).and_return(
        'access_token' => 'test-access-token'
      )

      resolved = subject.resolve
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:access_token]).to eq('test-access-token')

    end

    it 'fails resolving the access token' do

      allow_any_instance_of(described_class).to receive(:gateway).and_return(
        'access_token' => 'test-access-token',
        'errcode' => '1',
        'errmsg' => 'random error'
      )

      resolved = subject.resolve
      expect(resolved.success?).to eq(false)
      expect(resolved.error).to eq('random error')

    end

  end

end
