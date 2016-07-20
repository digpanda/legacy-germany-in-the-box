module BorderGuruFtp
  class TransferOrders
    module Senders
      class Push < Base

        attr_reader :connection, :file_path, :file

        def initialize(connection, file_path)
          @connection = connection
          @file_path = file_path
          @file = open(file_path)
        end

        def to_remote
          move
          destroy
        rescue Exception => exception
          raise BorderGuruFtp::Error, "Impossible to transfer file (#{exception})"
        ensure
          close
        end

        private

        def open(file_path)
          File.open(file_path, "r")
        end

        def move
          connection.putbinaryfile(file)
          connection.quit()
        end

        def destroy
          File.delete(file)
        end

        def close
          file.close unless file.nil?
        end

      end
    end
  end
end
