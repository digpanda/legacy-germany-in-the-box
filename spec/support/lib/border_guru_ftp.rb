require 'border_guru_ftp'
require 'fileutils'

module Helpers
  module Lib
    module BorderGuruFtp

      def border_guru_ftp_remote_test_files(ftp)
        ftp.nlst.select { |e| e.match(/-TEST-/) }
      end

      def border_guru_ftp_clean_up_remote_test_files(ftp)
        border_guru_ftp_remote_test_files(ftp).each { |file| ftp.delete(file) }
        ftp.quit
      end

      def border_guru_ftp_pre_clean_remote_test_files
        Net::FTP.new.tap do |ftp|
          ftp.connect(::BorderGuruFtp::CONFIG[:ftp][:host], ::BorderGuruFtp::CONFIG[:ftp][:port])
          ftp.login(::BorderGuruFtp::CONFIG[:ftp][:username], ::BorderGuruFtp::CONFIG[:ftp][:password])
          ftp.chdir(::BorderGuruFtp::CONFIG[:ftp][:remote_directory])
          border_guru_ftp_clean_up_remote_test_files(ftp)
        end
      end
      
    end
  end
end
