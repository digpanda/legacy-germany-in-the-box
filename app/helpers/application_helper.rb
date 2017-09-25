module ApplicationHelper
  include Mobvious::Rails::Helper

  def setting
    @setting ||= Setting.instance
  end

  def weixin_debug
    if Rails.env.production?
      false
    else
      true
    end
  end
end
