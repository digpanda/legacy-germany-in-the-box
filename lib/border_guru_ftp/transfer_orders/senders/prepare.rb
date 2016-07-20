module BorderGuruFtp
  class TransferOrders
    module Senders
      class Prepare < Base

        def fetch
          Dir.chdir(BorderGuruFtp.local_directory)
          Dir.glob('*/**').select(&:itself)
        end
        
      end
    end
  end
end
