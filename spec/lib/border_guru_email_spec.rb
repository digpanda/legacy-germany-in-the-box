require 'border_guru_email'

describe BorderGuruEmail do

  let(:log_file) { "#{Rails.root}/log/#{BorderGuruEmail::CONFIG[:email][:log]}" }
  before(:each) { File.delete(log_file) if File.exists?(log_file) }
  before { HermesMailer.deliveries = [] }

  context "#transmit_orders" do

    it "shouldn't transmit orders which aren't ready" do
      # those orders are deliberately not on `custom_checking` to see if it breaks
      # it shouldn't. but it shouldn't send any email either (because no minimum sending date)
      orders = create_list(:order, 10)
      transmit = BorderGuruEmail.transmit_orders(orders)
      expect(transmit).to be_a(BorderGuruEmail::TransmitOrders)
      expect(HermesMailer.deliveries.count).to eq(0) # no email sent
    end

    it "shouldn't transmit orders which are still under custom checking" do
      orders = create_list(:order, 5, :with_custom_checking)
      transmit = BorderGuruEmail.transmit_orders(orders)
      expect(transmit).to be_a(BorderGuruEmail::TransmitOrders)
      expect(HermesMailer.deliveries.count).to eq(0) # no email sent
    end

    it "should transmit one email for all the orders of one shop" do
      orders = create(:shop, :with_shippable_orders).orders
      transmit = BorderGuruEmail.transmit_orders(orders)
      expect(transmit).to be_a(BorderGuruEmail::TransmitOrders)
      expect(HermesMailer.deliveries.count).to eq(1) # only one email
    end

    it "should transmit one email per order" do
      orders = create_list(:order, 5, :with_shippable)
      transmit = BorderGuruEmail.transmit_orders(orders)
      expect(transmit).to be_a(BorderGuruEmail::TransmitOrders)
      expect(HermesMailer.deliveries.count).to eq(5)
    end

  end

  context "#log" do

    it "should log something in the correct folder" do
      paragraph = Faker::Lorem.paragraph
      BorderGuruEmail.log(paragraph)
      file = File.open(log_file, "r")
      expect(file.read).to include(paragraph)
    end

  end

end
