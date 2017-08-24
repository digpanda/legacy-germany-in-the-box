module ApplicationHelper
  include Mobvious::Rails::Helper

  def setting
    @setting ||= Setting.instance
  end

  def inside_layout(parent_layout='application')
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end

  def weixin_debug
    if Rails.env.production?
      false
    else
      true
    end
  end

end
