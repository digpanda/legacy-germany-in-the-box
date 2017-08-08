describe ProvisionHandler do

  context '#refresh!' do

    # order with referrer and which was bought
    # provision > 0
    let(:order) { FactoryGirl.create(:order, :with_referrer, status: :paid) }

    it 'should add a new provision and then remove it' do
      # ProvisionHandler.new(order).refresh! <- it's automatically generated on saving
      expect(order.referrer.provisions.count).to eq(1)
      expect(order.referrer.provisions.first.provision).to be > 0.0
      order.status = :cancelled
      order.save
      # ProvisionHandler.new(order).refresh! <- it's automatically generated on saving
      expect(order.referrer.provisions.count).to eq(0)
    end

  end
end
