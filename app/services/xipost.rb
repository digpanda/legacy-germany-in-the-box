class Xipost < BaseService

  UID = "kacam".freeze
  KEY = "9f74e107b1519718584af77847deb5b2".freeze

  class << self

    def tracking_url(order)
      "http://xipost.de/dhlstatus.php?dhl=#{order.id}&uid=#{UID}"
    end

    def identity_form
      @identity_form ||= Net::HTTP.get_response(URI.parse(identity_remote_url)).body.force_encoding('UTF-8')
    end

    private

    def identity_remote_url
      "http://www.xipost.de/api15.php?uid=#{UID}f&key=#{KEY}&i=uiNewIdCard&type=ui"
    end

  end

end
