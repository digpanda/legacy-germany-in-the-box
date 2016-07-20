module BorderGuruFtp
  class TransferOrders
    module Senders
      class Push < Base

        attr_reader :remote_connection, :local_files

        def initialize(remote_connection, local_files)
          @remote_connection = remote_connection
          @local_files = local_files
        end

        def to_remote
          local_files.each { |file_path| open_and_move(file_path) }
        end

        private

        def open_and_move(file_path)
          file = open(file_path)
          move(file)
          destroy(file)
        rescue Exception => exception
          raise BorderGuruFtp::Error, "Impossible to transfer file (#{exception})"
        ensure
          file.close unless file.nil?
        end

        def open(file_path)
          File.open(file_path, "r")
        end

        def destroy(file)
          File.delete(file)
        end

        def move(file)
          remote_connection.putbinaryfile(file)
          remote_connection.quit()
        end

      end
    end
  end
end
