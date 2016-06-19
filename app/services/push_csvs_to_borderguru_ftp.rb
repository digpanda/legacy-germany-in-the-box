#
# Take all the files (e.g. CSVs) stored on our local folder
# Serialize them and uploads them to BorderGuru FTP
# Then they are removed from our local server one after the other prevent crashing conflicts
#
class PushCsvsToBorderguruFtp < BaseService

  attr_reader :borderguru_local_directory, :borderguru_remote_directory, :ftp_host, :ftp_port, :ftp_username, :ftp_password

  def initialize

    @borderguru_local_directory ||= "#{::Rails.root}#{::Rails.application.config.border_guru['ftp']['local_directory']}"
    @borderguru_remote_directory ||= ::Rails.application.config.border_guru['ftp']['remote_directory']
    @ftp_host ||= ::Rails.application.config.border_guru['ftp']['host']
    @ftp_port ||= ::Rails.application.config.border_guru['ftp']['port']
    @ftp_username ||= ::Rails.application.config.border_guru['ftp']['username']
    @ftp_password ||= ::Rails.application.config.border_guru['ftp']['password']

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

    success

  end

  private

  def transfert_merchant_orders(csv_file_path)

    begin

      ftp = Net::FTP.new
      ftp.connect(ftp_host, ftp_port)  # here you can pass a non-standard port number
      ftp.login(ftp_username, ftp_password)
      ftp.chdir(borderguru_remote_directory)
      #ftp.passive = true  # optional, if PASV mode is required

      file = File.open(csv_file_path, "w")
      ftp.putbinaryfile(file)
      ftp.quit()
      
      # We don't forget to delete the file in the local version
      File.delete(file)

      return success

    rescue Exception => e
      return error(e)
    ensure
      file.close unless file.nil?
    end


  end


end