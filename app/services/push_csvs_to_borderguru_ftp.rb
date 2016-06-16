class PushCsvsToBorderguruFtp

  attr_reader :borderguru_local_directory, :ftp_host, :ftp_port, :ftp_username, :ftp_password

  def initialize

    @borderguru_local_directory ||= "#{::Rails.root}/public/uploads/borderguru/"
    @ftp_host ||= '84.200.54.181'
    @ftp_port ||= '1348'
    @ftp_username ||= 'ftp'
    @ftp_password ||= 'doNotAllowRetryMoreThan019'

  end

  def perform
    
    FileUtils.mkdir_p(borderguru_local_directory) unless File.directory?(borderguru_local_directory)
    Dir.chdir(borderguru_local_directory)
    folders = Dir.glob('*').select {|f| File.directory? f}

    folders.each do |folder|

      Dir["#{borderguru_local_directory}#{folder}/*"].each do |csv_file_path|
        transfered = transfert_merchant_orders(csv_file_path)
        return transfered if transfered[:success] == false
      end

    end

    return {:success => true}

  end

  private

  def transfert_merchant_orders(csv_file_path)

    begin

      remote_folder = "/CainiaoPreAlertCsv/files"

      ftp = Net::FTP.new
      ftp.connect(ftp_host, ftp_port)  # here you can pass a non-standard port number
      ftp.login(ftp_username, ftp_password)
      ftp.chdir(remote_folder)
      #ftp.passive = true  # optional, if PASV mode is required

      file = File.open(csv_file_path, "w")
      ftp.putbinaryfile(file)
      ftp.quit()
      
      # We don't forget to delete the file in the local version
      File.delete(file)

      return {success: true}

    rescue Exception => e
      return {success: false, error: e}
    ensure
      file.close unless file.nil?
    end


  end


end