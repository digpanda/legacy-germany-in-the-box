require 'border_guru_ftp'
require 'fileutils'

module Helpers
  module BorderGuruFtp

    module_function

    def border_guru_ftp_remove_push_traces

    end

    def border_guru_ftp_remove_local_directories
      #FileUtils.rm_rf(::BorderGuruFtp.local_directory) if File.exists?(::BorderGuruFtp.local_directory)
    end

  end
end