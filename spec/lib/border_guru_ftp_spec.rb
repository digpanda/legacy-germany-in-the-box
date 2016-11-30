describe BorderGuruFtp do

  let(:log_file) { "#{Rails.root}/log/#{BorderGuruFtp::CONFIG[:ftp][:log]}-#{Time.now.strftime('%Y-%m-%d')}.log" }
  let(:orders) { create_list(:order, 10) }
  before(:each) { File.delete(log_file) if File.exists?(log_file) }

  context "#transfer_orders" do

    it "should process the separated orders" do
      transfer = BorderGuruFtp.transfer_orders(orders)
      # we are limited into the lookup here, we are doing more investigation down the subclasses
      expect(transfer).to be_a(BorderGuruFtp::TransferOrders)
    end

  end

  context "#log" do

    it "should log something in the correct folder" do
      paragraph = Faker::Lorem.paragraph
      BorderGuruFtp.log(paragraph)
      file = File.open(log_file, "r")
      expect(file.read).to include(paragraph)
    end

  end

  context "#local_directory" do
    # we are not testing much here
    # maybe there's a better way to abstract that variable other than a whole method
    it "should equals some specific value" do
      expect(BorderGuruFtp.local_directory).to eq("#{Rails.root}#{BorderGuruFtp::CONFIG[:ftp][:local_directory]}")
    end
  end

end
