class Xipost < BaseService

  UID = "kacam".freeze
  KEY = "9f74e107b1519718584af77847deb5b2".freeze

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def tracking_url(order)
    "http://xipost.de/dhlstatus.php?dhl=#{order.id}&uid=#{UID}"
  end

  def identity_form
    @identity_form ||= Net::HTTP.get_response(URI.parse(identity_remote_url)).body.force_encoding('UTF-8')
  end

  def identity_remote_url
    "https://www.xipost.de/api15.php?uid=#{UID}f&key=#{KEY}&i=uiNewIdCard&type=ui&#{extra_data}"
  end

  private

  def extra_data
    "data%5Bidname%5D=#{user.decorate.chinese_full_name}&data%5Bidno%5D=#{user.primary_address&.pid}"
  end

end
