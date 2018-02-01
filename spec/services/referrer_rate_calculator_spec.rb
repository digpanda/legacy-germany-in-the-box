describe ReferrerRateCalculator  do

  context '#solve' do

    # TODO : make the with parent referrer
    let(:customer) { FactoryGirl.create(:customer, :with_parent_referrer) }

    it 'gets the referrer rate right' do
      # get the referre rate calculation rate depending the parent referrer user.group
    end
  end

end
