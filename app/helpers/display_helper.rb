module DisplayHelper
  # add small tips anywhere in the system
  # we pass through helpers and then partial
  # to make it short and flexible within the view
  def js_tips(locals={})
    render partial: "shared/partials/tips", :locals => locals
  end

  def boolean_icon(value)
    if value
      """
      <i class='fa fa-check-circle +green +big'></i>
      """.html_safe
    else
      """
      <i class='fa fa-times-circle +red +big'></i>
      """.html_safe
    end
  end
end
