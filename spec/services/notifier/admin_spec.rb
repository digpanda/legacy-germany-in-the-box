describe Notifier::Admin, :type => :mailer do

  context "#referrer_claimed_money" do

    let(:admin) { FactoryGirl.create(:admin) }
    let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }

    it "should send an email" do
      Notifier::Admin.new.referrer_claimed_money(referrer)
      expect(AdminMailer.deliveries.count).to eq(1)
    end

  end

end
