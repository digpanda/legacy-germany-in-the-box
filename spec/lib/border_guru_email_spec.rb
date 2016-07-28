describe BorderGuruEmail do

  LOG_FILE = "#{Rails.root}/log/#{BorderGuruEmail::CONFIG[:email][:log]}"

  let(:orders) { create_list(:order, 10) }
  before(:each) { File.delete(LOG_FILE) if File.exists?(LOG_FILE) }

  context "#transmit_orders" do

    it "should transmit the separated orders" do
      transmit = BorderGuruEmail.transmit_orders(orders)
      expect(transmit).to be_a(BorderGuruFtp::TransmitOrders)
    end

  end

  context "#log" do

    it "should log something in the correct folder" do
      paragraph = Faker::Lorem.paragraph
      BorderGuruEmail.log(paragraph)
      file = File.open(LOG_FILE, "r")
      expect(file.read).to include(paragraph)
    end

  end

end
