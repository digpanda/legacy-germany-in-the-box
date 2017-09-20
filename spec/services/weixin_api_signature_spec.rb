describe WeixinApiSignature  do

  context '#resolve' do

    subject(:subject) { described_class.new(request: request, ticket: ticket, nonce_str: 'random', timestamp: 99999) }
    let(:request) { double('request', original_url: 'http://test.com', session: {}, params: {}) }
    let(:ticket) { 'random ticket' }

    it 'returns a signature' do

      resolved = subject.resolve
      expect(resolved.success?).to eq(true)
      expect(resolved.data).to include(:signature)

    end

  end

end
