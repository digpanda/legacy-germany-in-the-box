class Xipost < BaseService

  UID = "kacam".freeze
  KEY = "9f74e107b1519718584af77847deb5b2".freeze

  attr_reader :user

  class << self
    # the static method doesn't include anything related to the user
    def identity_remote_url
      "https://www.xipost.de/api15.php?uid=#{UID}f&key=#{KEY}&i=uiNewIdCard&type=ui"
    end
  end

  def initialize(user)
    @user = user
  end

  def tracking_url(order)
    "http://xipost.de/dhlstatus.php?dhl=#{order.id}&uid=#{UID}"
  end

  def identity_remote_url
    "#{Xipost.identity_remote_url}&#{extra_data}"
  end

  def identity_form
    @identity_form ||= remote_content.body.force_encoding('UTF-8')
  end

  private

  def remote_content
    Net::HTTP.get_response(uri_remote_url)
  end

  def uri_remote_url
    URI.parse(identity_remote_url)
  end

  private

  def extra_data
    if user
      "data%5Bidname%5D=#{user.decorate.full_name}&data%5Bidno%5D=#{user.primary_address&.pid}"
    end
  end

end
