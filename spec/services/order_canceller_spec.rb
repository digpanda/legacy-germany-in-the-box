describe OrderCanceller do

  context '#all!' do

    it 'cancels a bought order' do
      order = FactoryGirl.create(:order, status: :paid)
      canceller = OrderCanceller.new(order).all!
      expect(canceller.success?).to eq(true)
      expect(order.status).to eq(:cancelled)
    end

    it 'fails to cancel an already cancelled order' do
      order = FactoryGirl.create(:order, status: :cancelled)
      canceller = OrderCanceller.new(order).all!
      expect(canceller.success?).to eq(false)
    end

    # LATER AFTER REFACTORING
    it 'removes completely an order which was not bought' do
      # NOTE : don't forget to check the stocks too
    end

  end

end
