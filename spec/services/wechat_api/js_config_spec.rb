describe WechatApi::JsConfig  do

  context '#resolve' do

    subject(:subject) { described_class.new(request: request, ticket: ticket) }
    let(:request) { double('request', original_url: 'http://test.com', session: {}, params: {}) }
    let(:ticket) { 'random ticket' }

    it 'returns a configuration' do

      allow_any_instance_of(described_class).to receive(:signature).and_return(
        'random signature'
      )

      resolved = subject.resolve
      expect(resolved.success?).to eq(true)
      expect(resolved.data).to include(:app_id, :timestamp, :nonce_str, :signature, :js_api_list)

    end

    it 'fails resolving the signature' do

      allow_any_instance_of(described_class).to receive(:signature_gateway).and_return(
        BaseService.new.return_with(:error, 'random error')
      )

      resolved = subject.resolve
      expect(resolved.success?).to eq(false)
      expect(resolved.error).to eq('random error')

    end

  end

end
