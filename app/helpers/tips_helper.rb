module TipsHelper

  # add small tips anywhere in the system
  # we pass through helpers and then partial
  # to make it short and flexible within the view
  def js_tips(locals={})
    render partial: "shared/partials/tips", :locals => locals
  end
end
