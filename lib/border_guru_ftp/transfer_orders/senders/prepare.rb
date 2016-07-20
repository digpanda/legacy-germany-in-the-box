module BorderGuruFtp
  class TransferOrders
    module Senders
      class Prepare < Base

        # fetch all the files to send from the local directory
        def fetch
          Dir.chdir(BorderGuruFtp.local_directory)
          Dir.glob('*/**').select(&:itself)
        end
        
      end
    end
  end
end
