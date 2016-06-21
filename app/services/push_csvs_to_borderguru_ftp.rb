#
# Take all the files (e.g. CSVs) stored on our local folder
# Serialize them and uploads them to BorderGuru FTP
# Then they are removed from our local server one after the other to prevent crashing conflicts
#
class PushCsvsToBorderguruFtp < BaseService

  attr_reader :borderguru, :borderguru_local_directory

  def initialize

    @borderguru = Rails.application.config.border_guru
    @borderguru_local_directory = "#{Rails.root}#{borderguru[:ftp][:local_directory]}"

  end

  def perform
    open_directory! borderguru_local_directory
    fetch_current_directory :folders do |folder|
      open_directory folder
      fetch_current_directory :files do |files|
        transfered = transfert_merchant_orders(files)
        return transfered unless transfered.success?
      end
    end
    return_with(:success)
  end

  private

  def transfert_merchant_orders(csv_file_path)
    begin
      ftp = connect_and_go(borderguru[:ftp])
      file = push_and_destroy(ftp, file)
      return_with(:success)
    rescue Exception => e
      return_with(:error, e)
    ensure
      file.close unless file.nil?
    end
  end

  ## FILE MANIP
  def create_directory!(directory)
    FileUtils.mkdir_p(directory) unless File.directory?(directory)
  end

  def open_directory!(directory)
    create_directory! borderguru_local_directory
    open_directory(directory)
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
  
  ## FTP MANIP
  def connect_and_go(credentials)
    ftp = Net::FTP.new
    ftp.connect(credentials[:host], credentials[:port])
    ftp.login(credentials[:username], credentials[:password])
    ftp.chdir(credentials[:remote_directory])
    ftp
  end

  def push_and_destroy(ftp_instance, file)
    file = File.open(csv_file_path, "w")
    ftp_instance.putbinaryfile(file)
    ftp_instance.quit()
    File.delete(file)
    file
  end
  ## FTP MANIP

end