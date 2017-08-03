describe Currency do

  let(:rate) { Setting.instance.exchange_rate_to_yuan.to_f }

  context '#to_yuan' do

    it 'should return Currency object' do
      expect(Currency.new(20).to_yuan).to be_a(Currency)
    end

    it 'should convert to yuan' do
      expect(Currency.new(20).to_yuan.amount.to_f).to eql(20.00 * rate)
    end

    it 'should convert to euro and back to yuan' do
      # state data test
      currency = Currency.new(150, 'CNY')
      expect(currency.to_euro).to be_a(Currency)
      expect(currency.to_yuan).to be_a(Currency)
      expect(currency.amount.to_f).to eql(150.00)
    end

  end

  context '#to_euro' do

    it 'should convert to euro' do
      expect(Currency.new(150, 'CNY').to_euro.amount.to_f).to eql(150 / rate)
    end

  end

  context '#display' do

    it 'should display euros' do
      expect(Currency.new(10, 'EUR').display).to eql('€ 10.00')
    end

    it 'should display yuan' do
      expect(Currency.new(60.50, 'CNY').display).to eql('¥ 60.50')
    end

  end

end
