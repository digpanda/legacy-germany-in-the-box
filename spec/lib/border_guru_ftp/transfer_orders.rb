include Helpers::BorderGuruFtp

describe BorderGuruFtp::TransferOrders do

  LOG_FILE = "#{Rails.root}/log/#{BorderGuruFtp::CONFIG[:ftp][:log]}"

  before(:each) do
    FileUtils.rm_rf(BorderGuruFtp.local_directory)
    File.delete(LOG_FILE) if File.exists?(LOG_FILE)

  end

  context "#generate_and_store_local" do

    it "should generate one CSV file locally" do

      shop = create(:shop, :with_orders)
      BorderGuruFtp::TransferOrders.new(shop.orders).generate_and_store_local
      Dir.chdir(BorderGuruFtp.local_directory) do # buggy rspec when not used into a scope
        expect(Dir.glob('*/**').select(&:itself).length).to eq(1)
      end

    end

    it "should generate 10 CSV files from different shops" do

      orders = create_list(:order, 10)
      BorderGuruFtp::TransferOrders.new(orders).generate_and_store_local
      Dir.chdir(BorderGuruFtp.local_directory) do # buggy rspec when not used into a scope
        expect(Dir.glob('*/**').select(&:itself).length).to eq(10)
      end

    end

  end

=begin
  context "#connect_and_push_remote" do

    it "" do
    end

  end

  context "#clean_local_storage" do

    it "" do
    end

  end
=end
end
