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
    
    create_directory! borderguru_local_directory
    open_directory borderguru_local_directory

    fetch_current_directory :folders do |folder|

      open_directory folder
      fetch_current_directory :files do |files|
        transfered = transfert_merchant_orders(files)
        return transfered if transfered[:success] == false
      end

    end

    success

  end

  private

  ## FILE MANIP
  def create_directory!(directory)
    FileUtils.mkdir_p(directory) unless File.directory?(directory)
  end

  def open_directory(directory)
    Dir.chdir(directory)
  end

  def fetch_current_directory(type, &block)
    Dir.glob('*').select do |f|
      case type
      when :folders
        File.directory? f
      when :files
        !(File.directory? f)
      end
    end.each { |file| block.call(file) }
  end
  ## FILE MANIP

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