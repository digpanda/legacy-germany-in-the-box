module TipsHelper
  def js_tips(locals={})
    render partial: "shared/partials/tips", :locals => locals
  end
end
