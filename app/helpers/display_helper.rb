module DisplayHelper
  # add small tips anywhere in the system
  # we pass through helpers and then partial
  # to make it short and flexible within the view
  def js_tips(locals={})
    render partial: "shared/partials/tips", :locals => locals
  end

  # new: new
  # signature_received: signature received
  # processing: processing
  # accepted: accepted
  # local_distribution: local distribution
  # problem: problem
  # signature_returned: signature returned
  # returned: returned
  def colorful_tracking_state(tracking_state)
    if [:new].include? tracking_state
      "<span class=\"+dark-grey +bold\">#{I18n.t("tracking_state.#{tracking_state}")}</span>".html_safe
    elsif [:signature_received].include? tracking_state
      "<span class=\"+green +bold\">#{I18n.t("tracking_state.#{tracking_state}")}</span>".html_safe
    elsif [:processing, :accepted, :local_distribution].include? tracking_state
      "<span class=\"+blue +bold\">#{I18n.t("tracking_state.#{tracking_state}")}</span>".html_safe
    elsif [:problem, :signature_returned, :returned]
      "<span class=\"+red +bold\">#{I18n.t("tracking_state.#{tracking_state}")}</span>".html_safe
    else
      tracking_state
    end
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
