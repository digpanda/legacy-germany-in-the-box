class QrcodeHandler < BaseService
  attr_reader :remote_url, :local_path, :file_name

  def initialize(remote_url, local_path, file_name)
    @remote_url = remote_url
    @local_path = local_path
    @file_name = file_name
  end

  def perform
    make_image! unless file_already_stored?
    full_path
  end

  private

    def make_image!
      FileUtils.mkdir_p(local_storage)
      IO.write(full_storage, svg)
    end

    def file_already_stored?
      File.exist?(full_storage)
    end

    def full_storage
      "#{local_storage}#{file_name}"
    end

    # full local path with the public directory to write the image
    def local_storage
       "#{Rails.root}/public#{local_path}"
    end

    def full_path
      "#{local_path}#{file_name}"
    end

    def qrcode
      @qrcode ||= ::RQRCode::QRCode.new(remote_url)
    end

    def svg
      @qrcode_svg = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 11)
    end
end
