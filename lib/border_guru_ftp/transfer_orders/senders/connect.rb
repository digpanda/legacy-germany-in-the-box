module BorderGuruFtp
  class TransferOrders
    module Senders
      class Connect < Base

        def establish
          Net::FTP.new.tap do |ftp|
            ftp.connect(CONFIG[:ftp][:host], CONFIG[:ftp][:port])
            ftp.login(CONFIG[:ftp][:username], CONFIG[:ftp][:password])
            ftp.chdir(CONFIG[:ftp][:remote_directory])
          end
        end

      end
    end
  end
end
