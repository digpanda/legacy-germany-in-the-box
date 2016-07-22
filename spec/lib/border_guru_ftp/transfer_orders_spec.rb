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

    it "should generate 10 CSV files from different shops in 10 different folders" do
      orders = create_list(:order, 10)
      BorderGuruFtp::TransferOrders.new(orders).generate_and_store_local
      Dir.chdir(BorderGuruFtp.local_directory) do # buggy rspec when not used into a scope
        expect(Dir.glob('*/**').select(&:itself).length).to eq(10)
        expect(Dir.glob('*').select(&:itself).length).to eq(10)
        expect(Dir.glob('*').select(&:itself).first).to eq("#{orders.first.shop.id}")
      end
    end

    it "should not convert orders without item into a CSV" do
      orders = create_list(:order, 10, :without_item)
      BorderGuruFtp::TransferOrders.new(orders).generate_and_store_local
      FileUtils.mkdir_p(BorderGuruFtp.local_directory)
      Dir.chdir(BorderGuruFtp.local_directory) do # buggy rspec when not used into a scope
        expect(Dir.glob('*/**').select(&:itself).length).to eq(0)
      end
    end

  end

  context "#connect_and_push_remote" do

    it "should push the file and be present on the FTP" do

      orders = create_list(:order, 5)
      BorderGuruFtp::TransferOrders.new(orders).tap do |transfer|
        transfer.generate_and_store_local
        transfer.connect_and_push_remote
      end
      Net::FTP.new.tap do |ftp|
        ftp.connect(BorderGuruFtp::CONFIG[:ftp][:host], BorderGuruFtp::CONFIG[:ftp][:port])
        ftp.login(BorderGuruFtp::CONFIG[:ftp][:username], BorderGuruFtp::CONFIG[:ftp][:password])
        ftp.chdir(BorderGuruFtp::CONFIG[:ftp][:remote_directory])
        binding.pry
        #ftp.list
      end
      # check realness on FTP
      # clean files on FTP (could become part of the library itself, it's useful)
      
    end

  end

  context "#clean_local_storage" do

    it "clean all files contained in the target folder" do

      orders = create_list(:order, 10)
      BorderGuruFtp::TransferOrders.new(orders).tap do |transfer|
        # could be replaced by a manual file / folder creation 
        # to avoid inter-dependance with other methods
        # (but right now it's enough, if it breaks at any point, please chage this)
        transfer.generate_and_store_local # tested before
        transfer.clean_local_storage
      end
      FileUtils.mkdir_p(BorderGuruFtp.local_directory)
      Dir.chdir(BorderGuruFtp.local_directory) do # buggy rspec when not used into a scope
        expect(Dir.glob('*/**').select(&:itself).length).to eq(0)
      end

    end

  end

end
