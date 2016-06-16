class PushCsvToBorderguruFtp

  class << self

    def perform(args={})

      csv_file_path = args[:csv_file_path]

      ftp = Net::FTP.new
      ftp.connect('84.200.54.181', '1348')  # here you can pass a non-standard port number
      ftp.login('ftp','doNotAllowRetryMoreThan019')
      #ftp.passive = true  # optional, if PASV mode is required

      file = File.open(csv_file_path, "w")
      ftp.putbinaryfile(file)
      ftp.quit()

=begin
    file = File.open("public/uploads/borderguru/#{order.shop.id}/#{formatted_date}_#{borderguru_merchant_id}.csv", "w")
    ftp = Net::FTP.new('84.200.54.181')
    ftp.login(user = "***", passwd = "doNotAllowRetryMoreThan019")
    ftp.putbinaryfile(file.read, File.basename(file.original_filename))
    ftp.quit()
=end

    end

  end

end