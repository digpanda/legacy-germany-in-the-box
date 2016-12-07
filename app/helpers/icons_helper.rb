module IconsHelper
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
