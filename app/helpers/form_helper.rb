module FormHelper

  def guess_coupon_label
    if session[:origin] == :wechat
      I18n.t(:coupon_mobile, scope: :coupon)
    else
      I18n.t(:coupon_desktop, scope: :coupon)
    end
  end

  def logistic_partners
    [['Xipost', :xipost], ['Beihai', :beihai], ['MKPost', :mkpost], ['Manual', :manual]]
  end

  def orders_status
    [["New", :new], ["Paying", :paying], ["Payment Unverified", :unverified], ["Payment failed", :failed],
    ["Cancelled", :cancelled], ["Paid", :paid], ["Custom Checkable", :custom_checkable],
    ["Custom Checking", :custom_checking], ["Shipped", :shipped]]
  end

  def order_payments_status
    [["Scheduled", :scheduled], ["Unverified", :unverified], ["Success", :success], ["Failed", :failed]]
  end

  def every(form, limit)
    (form.index + 1) % limit == 0
  end

  def solve_index
    @solve_index = 0 unless @solve_index
    @solve_index += 1
  end

end
