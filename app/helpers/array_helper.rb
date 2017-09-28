module ArrayHelper
  def inquiry_status
    { 'New' => :new, 'Replied' => :replied, 'Confirmed' => :confirmed, 'Rejected' => :rejected, 'Paid' => :paid, 'Terminated' => :terminated }
  end

  def project_versions
    [['Alpha', :alpha], ['Beta', :beta], ['Stable', :stable]]
  end

  def boolean_select
    [['Yes', true], ['No', false]]
  end

  def user_roles
    [['Administrator', :admin], ['Shopkeeper', :shopkeeper], ['Customer', :customer]]
  end

  def parent_referrers
    Referrer.all.reduce([]) do |acc, referrer|
      acc << ["#{referrer.user.decorate.full_name} (#{referrer.reference_id})", referrer.id]
    end
  end

  def delivery_providers
    { 'Postelbe' => 'postelbe', 'DHLDE' => 'dhlde', 'EMS' => 'ems', 'EMS Guoji' => 'emsguoji' }
  end

  def logistic_partners
    [['Beihai', :beihai], ['MKPost', :mkpost], ['Manual', :manual]]
  end

  def orders_status
    [['New', :new], ['Paying', :paying], ['Payment Unverified', :unverified], ['Payment failed', :failed],
    ['Cancelled', :cancelled], ['Paid', :paid], ['Shipped', :shipped], ['Terminated', :terminated]]
  end

  def order_payments_status
    [['Scheduled', :scheduled], ['Unverified', :unverified], ['Success', :success], ['Failed', :failed]]
  end
end
