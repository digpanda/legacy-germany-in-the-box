module BorderGuruFtp
  class TransferOrders
    module Senders
      class Prepare < Base

        # fetch all the files to send from the local directory
        def fetch
          FileUtils.mkdir_p(BorderGuruFtp.local_directory)
          Dir.chdir(BorderGuruFtp.local_directory) do
            Dir.glob('*/**').select(&:itself)
          end
        end
        
      end
    end
  end
end
