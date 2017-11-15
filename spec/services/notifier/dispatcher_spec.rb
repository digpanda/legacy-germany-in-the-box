describe Notifier::Dispatcher, type: :mailer do

  before(:each) do
    allow_any_instance_of(PhoneMessenger).to receive(:send).and_return({})
  end

  context '#perform' do

    let(:customer) { FactoryGirl.create(:customer) }

    it 'should send a notification and an Email' do
      Notifier::Dispatcher.new(
        user: customer,
        title: 'Fake title',
        desc: 'Fake description',
        url: 'http://test.com'
      ).perform

      expect(Notification.count).to eq(1)
      expect(CustomerMailer.deliveries.count).to eq(1)
    end

    it 'should send an Email without user defined' do
      Notifier::Dispatcher.new(
        email: 'email@email.com',
        mailer: CustomerMailer,
        title: 'Fake title',
        desc: 'Fake description',
        url: 'http://test.com'
      ).perform

      expect(Notification.count).to eq(0)
      expect(CustomerMailer.deliveries.count).to eq(1)
    end

    it 'should send only one notification and one email with unique id' do

      2.times do |time|

        Notifier::Dispatcher.new(
          user: customer,
          unique_id: 'test',
          title: "Fake title #{time}",
          desc: "Fake description #{time}",
          url: "http://test.com/#{time}"
        ).perform

      end

      expect(Notification.count).to eq(1)
      expect(CustomerMailer.deliveries.count).to eq(1)
    end

    it 'should send a SMS' do
      dispatch_sms = Notifier::Dispatcher.new(
        user: customer,
        title: 'Fake title',
        desc: 'Fake description', # this will be used
        url: 'http://test.com'
      ).perform(:sms)

      expect(dispatch_sms.success?).to eq(true) # sent successfully
      expect(Notification.count).to eq(1)
      expect(CustomerMailer.deliveries.count).to eq(0) # no email
    end

    context 'api throwing error' do

      before(:each) do
        allow_any_instance_of(PhoneMessenger).to receive(:send).and_raise(Twilio::REST::RequestError, "Fake wrong mobile")
      end

      it 'should not send a SMS' do

        customer.mobile = 'invalid'
        customer.save(validation: false)

        dispatch_sms = Notifier::Dispatcher.new(
          user: customer,
          title: 'Fake title',
          desc: 'Fake description', # this will be used
          url: 'http://test.com'
        ).perform(:sms)

        expect(dispatch_sms.success?).to eq(false) # not sent
      end

    end

    it 'should send a SMS and an email' do
      dispatch_sms = Notifier::Dispatcher.new(
        user: customer,
        title: 'Fake title',
        desc: 'Fake description', # this will be used
        url: 'http://test.com'
      ).perform(:sms, :email)

      expect(dispatch_sms.success?).to eq(true) # sent successfully
      expect(Notification.count).to eq(1)
      expect(CustomerMailer.deliveries.count).to eq(1) # no email
    end

    it 'should not save the same notification twice' do

      2.times do
        Notifier::Dispatcher.new(
          user: customer,
          title: 'Fake title',
          desc: 'Fake description',
          url: 'http://test.com'
        ).perform
      end

      expect(Notification.count).to eq(1)

    end

  end

end
