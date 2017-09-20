describe WeixinApiTicket  do

  context '#resolve' do

    subject(:subject) { described_class.new }

    it 'returns a ticket' do

      allow_any_instance_of(described_class).to receive(:access_token_gateway).and_return(
        BaseService.new.return_with(:success, access_token: 'random token')
      )

      allow_any_instance_of(described_class).to receive(:ticket_gateway).and_return(
          'ticket' => 'random ticket'
        )

      resolved = subject.resolve
      expect(resolved.success?).to eq(true)
      expect(resolved.data[:ticket]).to eq('random ticket')

    end

    it 'fails resolving the ticket' do

      allow_any_instance_of(described_class).to receive(:access_token_gateway).and_return(
        BaseService.new.return_with(:success, access_token: 'random token')
      )

      allow_any_instance_of(described_class).to receive(:ticket_gateway).and_return(
        'errcode' => '1',
        'errmsg' => 'random error'
      )

      resolved = subject.resolve
      expect(resolved.success?).to eq(false)
      expect(resolved.error).to eq('random error')

    end

  end

end
