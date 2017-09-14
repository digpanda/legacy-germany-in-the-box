class QrcodeHandler < BaseService
  attr_reader :remote_url, :local_storage

  def initialize(remote_url, local_path, file_name)
    @remote_url = remote_url
    @local_storage = local_storage
  end

  def perform
    FileUtils.mkdir_p(local_path)
    # under public folder, systematically
    IO.write("public#{full_path}", svg)
    full_path
  end

  private

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
