class SmartQrcode
  attr_reader :url, :uri

  def initialize(url)
    @url = url
    @uri = URI(url)
  end

  def perform
    qrcode_handler.perform
  end

  def destroy
    qrcode_handler.destroy_stored_file
  end

  def qrcode_handler
    @qrcode_handler ||= QrcodeHandler.new(url, local_file, full_file)
  end

  private

    def local_file
      "/uploads/qrcode/smart#{uri.path}"
    end

    def full_file
      "#{file_name}.svg"
    end

    def file_name
      Digest::MD5.hexdigest("#{url}")
    end
end
