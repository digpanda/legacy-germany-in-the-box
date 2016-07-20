module BorderGuruFtp
  class TransferOrders
    module Senders
      class Connect < Base

        attr_reader :current

        # establish a connection to BorderGuru FTP
        def establish!
          @current = Net::FTP.new.tap do |ftp|
            ftp.connect(CONFIG[:ftp][:host], CONFIG[:ftp][:port])
            ftp.login(CONFIG[:ftp][:username], CONFIG[:ftp][:password])
            ftp.chdir(CONFIG[:ftp][:remote_directory])
          end
        end

        # disconnect from BorderGuru FTP
        def leave!
          current.quit unless current.nil?
        end

      end
    end
  end
end
