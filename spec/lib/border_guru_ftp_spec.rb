describe BorderGuruFtp do

  LOG_FILE = "#{Rails.root}/log/#{BorderGuruFtp::CONFIG[:ftp][:log]}"

  let(:orders) { create_list(:order, 10) }
  before(:each) { File.delete(LOG_FILE) if File.exists?(LOG_FILE) }

  context "#transfer_orders" do

    it "should process the separated orders" do
      transfer = BorderGuruFtp.transfer_orders(orders)
      # we are limited into the lookup here, we are doing more investigation down the subclasses
      expect(transfer).to be_a(BorderGuruFtp::TransferOrders)
    end

  end

  context "#log" do

    it "should log something in the correct folder" do
      BorderGuruFtp.log("this is a fake log to see if it actually logs something")
      file = File.open(LOG_FILE, "r")
      expect(file.read).to include("this is a fake log to see if it actually logs something")
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
