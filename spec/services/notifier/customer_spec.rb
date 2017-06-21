require Rails.root.join('app/services/notifier/customer').to_s

describe Notifier::Customer, :type => :mailer do

  context "#welcome" do

    let(:customer) { FactoryGirl.create(:customer) }
    before(:each) { CustomerMailer.deliveries = [] }

    it "should send an email" do
      Notifier::Customer.new(customer).welcome
      expect(CustomerMailer.deliveries.count).to eq(1)
    end

  end

end
