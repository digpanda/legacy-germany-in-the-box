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

        # push the file to the remote server
        def to_remote
          move
          destroy
        rescue Exception => exception
          raise BorderGuruFtp::Error, "Impossible to transfer file (#{exception})"
        ensure
          close
        end

        private

        # we can't have more than a local scope here for testing purposes.
        # we should have the full path so we don't need to Dir.chdir every fucking file etc.
        # TODO before to stop working on that
        def open(file_path)
          Dir.chdir(BorderGuruFtp.local_directory) do
            File.open(file_path, "r")
          end
        end

        def move
          Dir.chdir(BorderGuruFtp.local_directory) do
            connection.putbinaryfile(file)
          end
        end

        def destroy
          Dir.chdir(BorderGuruFtp.local_directory) do
            File.delete(file)
          end
        end

        def close
          file.close if file.respond_to?(:close)
        end

      end
    end
  end
end
