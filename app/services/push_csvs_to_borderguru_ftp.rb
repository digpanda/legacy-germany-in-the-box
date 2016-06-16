class PushCsvsToBorderguruFtp

  def initialize

    borderguru_local_directory = "#{::Rails.root}/public/uploads/borderguru/"

    Dir.chdir(borderguru_local_directory)
    folders = Dir.glob('*').select {|f| File.directory? f}

    folders.each do |folder|

      csv_file_path = Dir["#{borderguru_local_directory}#{folder}/*"].join
      transfert_merchant_orders(csv_file_path)

    end

  end

  def transfert_merchant_orders(csv_file_path)

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