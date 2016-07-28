describe BorderGuruEmail do

  let(:log_file) { "#{Rails.root}/log/#{BorderGuruEmail::CONFIG[:email][:log]}" }
  let(:orders) { create_list(:order, 10) }
  before(:each) { File.delete(log_file) if File.exists?(log_file) }

  context "#transmit_orders" do

    it "should transmit the separated orders" do
      # those orders are deliberately not on `custom_checking` to see if it breaks
      # it shouldn't.
      transmit = BorderGuruEmail.transmit_orders(orders)
      expect(transmit).to be_a(BorderGuruEmail::TransmitOrders)
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
