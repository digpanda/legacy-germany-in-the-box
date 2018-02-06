describe ReferrerRateCalculator  do

  context '#solve' do

    let(:customer) { FactoryGirl.create(:customer, :with_parent_referrer) }
    let(:referrer) { customer.parent_referrer }

    context 'for product' do

      let(:order_item) { FactoryGirl.create(:order, user: customer).order_items.first }

      it 'gets the referrer rate right' do
        # we have to manually refresh the rates because this method is used
        # during the order, we don't put it as callback action in the model
        # because the referrer rate could be manually set after order.
        expect(order_item.referrer_rate).to eq(0.0)
        order_item.refresh_referrer_rate!
        expect(order_item.referrer_rate).to eq(10.0) # default referrer rate engaged by default

        # junior update should change the rate on refresh
        referrer.user.update!(group: :junior)
        order_item.refresh_referrer_rate!
        expect(order_item.referrer_rate).to eq(15.0)

        # senior update should change the rate on refresh
        referrer.user.update!(group: :senior)
        order_item.refresh_referrer_rate!
        expect(order_item.referrer_rate).to eq(20.0)
      end
    end

    context 'for package set' do

      let(:order_item) { FactoryGirl.create(:order, :with_package_sets, user: customer).order_items.first }

      it 'gets the referrer rate right' do
        expect(order_item.referrer_rate).to eq(0.0)
        order_item.refresh_referrer_rate!
        expect(order_item.referrer_rate).to eq(5.0) # default referrer rate engaged by default

        # junior update should change the rate on refresh
        referrer.user.update!(group: :junior)
        order_item.refresh_referrer_rate!
        expect(order_item.referrer_rate).to eq(10.0)

        # senior update should change the rate on refresh
        referrer.user.update!(group: :senior)
        order_item.refresh_referrer_rate!
        expect(order_item.referrer_rate).to eq(15.0)
      end

    end

     context 'without referrer' do

      let(:customer) { FactoryGirl.create(:customer) }
      let(:order_item) { FactoryGirl.create(:order, :with_package_sets, user: customer).order_items.first }

       it 'gets no provision rate because there is no referrer' do
         expect(order_item.referrer_rate).to eq(0.0)
         order_item.refresh_referrer_rate!
         expect(order_item.referrer_rate).to eq(0.0)
       end

     end

    # NOTE : service can't be tested because it's not in the order lifecycle
  end

end
