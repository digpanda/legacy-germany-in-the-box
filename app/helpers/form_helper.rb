module FormHelper

  def guess_coupon_label
    if session[:origin] == :wechat
      I18n.t(:coupon_mobile, scope: :coupon)
    else
      I18n.t(:coupon_desktop, scope: :coupon)
    end
  end

  def logistic_partners
    [['Border Guru', :borderguru],['Manual', :manual]]
  end

  def every(form, limit)
    (form.index + 1) % limit == 0
  end

  def solve_index
    @solve_index = 0 unless @solve_index
    @solve_index += 1
  end

end
