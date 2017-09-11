module ArrayHelper

  def project_versions
    [["Alpha", :alpha], ["Beta", :beta], ["Stable", :stable]]
  end

  def boolean_select
    [["Yes", true], ["No", false]]
  end

  def user_roles
    [['Administrator', :admin],['Shopkeeper', :shopkeeper],['Customer', :customer]]
  end

  def parent_referrers
    Referrer.all.reduce([]) do |acc, referrer|
      acc << ["#{referrer.user.decorate.full_name} (#{referrer.reference_id})", referrer.id]
    end
  end

  def delivery_providers
    {'Postelbe' => 'Postelbe', 'DHLDE' => 'dhlde', 'EMS' => 'ems'}
  end

  def logistic_partners
    [['Xipost', :xipost], ['Beihai', :beihai], ['MKPost', :mkpost], ['Manual', :manual]]
  end

  def orders_status
    [["New", :new], ["Paying", :paying], ["Payment Unverified", :unverified], ["Payment failed", :failed],
    ["Cancelled", :cancelled], ["Paid", :paid], ["Shipped", :shipped], ["Terminated", :terminated]]
  end

  def order_payments_status
    [["Scheduled", :scheduled], ["Unverified", :unverified], ["Success", :success], ["Failed", :failed]]
  end

end
