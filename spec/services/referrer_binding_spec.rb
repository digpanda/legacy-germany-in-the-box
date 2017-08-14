describe ReferrerBinding  do

  context '#bind' do

    let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }
    let(:customer) { FactoryGirl.create(:customer) }

    it 'bind a customer to the referrer' do

      ReferrerBinding.new(referrer).bind(customer)
      expect(customer.parent_referrer).to eq(referrer)

    end

    it 'does not bind a customer to the referrer because he already got one' do

      old_referrer = FactoryGirl.create(:customer, :with_referrer).referrer
      customer.parent_referrer = old_referrer
      customer.save(validate: false)

      ReferrerBinding.new(referrer).bind(customer)
      expect(customer.parent_referrer).to eq(old_referrer)

    end
  end

end
