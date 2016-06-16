class PushCsvToBorderguruFtp

  class << self

    def perform(args={})

      csv_file_path = args[:csv_file_path]
      csv_file_name = File.basename csv_file_path

      begin

        remote_folder = "/CainiaoPreAlertCsv/files"

        ftp = Net::FTP.new
        ftp.connect('84.200.54.181', '1348')  # here you can pass a non-standard port number
        ftp.login('ftp','doNotAllowRetryMoreThan019')
        ftp.chdir(remote_folder)
        #ftp.passive = true  # optional, if PASV mode is required

        file = File.open(csv_file_path, "r")
        ftp.putbinaryfile(file)
        ftp.quit()
        return true

      rescue Exception => e
        return false
      ensure
        file.close unless file.nil?
      end

    end

  end

end