describe Notifier::Shopkeeper, type: :mailer do

  context '#welcome' do

    let(:shopkeeper) { FactoryGirl.create(:shopkeeper) }
    before(:each) { ShopkeeperMailer.deliveries = [] }

    it 'should send an email' do
      Notifier::Shopkeeper.new(shopkeeper).welcome
      expect(ShopkeeperMailer.deliveries.count).to eq(1)
    end

  end

end
