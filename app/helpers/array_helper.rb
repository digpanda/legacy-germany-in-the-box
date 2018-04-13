module ArrayHelper

  def chinese_months
    {
      '一月'  => '01',
      '二月' => '02',
      '三月' => '03',
      '四月' => '04',
      '五月' => '05',
      '六月' => '06',
      '七月' => '07',
      '八月' => '08',
      '九月' => '09',
      '十月' => '10',
      '十一月' => '11',
      '十二月' => '12'
    }
  end

  def parent_referrers
    Referrer.all.reduce([]) do |acc, referrer|
      acc << ["#{referrer.user.decorate.full_name} (#{referrer.reference_id})", referrer.id]
    end
  end

  def user_groups
    {
      'Default' => :default,
      'Student' => :student,
      'Junior' => :junior,
      'Senior' => :senior
    }
  end

  def referrer_groups
    ReferrerGroup.all.reduce([]) do |acc, referrer_group|
      acc << [referrer_group.name, referrer_group.id]
    end
  end

  def inquiry_status
    {
      'New' => :new,
      'Replied' => :replied,
      'Confirmed' => :confirmed,
      'Rejected' => :rejected,
      'Paid' => :paid,
      'Terminated' => :terminated
    }
  end

  def project_versions
    {
      'Alpha' => :alpha,
      'Beta' => :beta,
      'Stable' => :stable
      }
  end

  def boolean_select
    {
      'Yes' => true,
      'No' => false
    }
  end

  def user_roles
    {
      'Administrator' => :admin,
      'Shopkeeper' => :shopkeeper,
      'Customer' => :customer
    }
  end

  def delivery_providers
    {
      'Postelbe' => :postelbe,
      '德国邮政' => :deutschepost,
      'EMS' => :ems,
      'EMS Guoji' => :emsguoji,
      'Adler' => :adlerlogi,
      'UEQ' => :ueq,
      'DHL德国国内' => :dhlde,
      '德国优拜' => :ubuy,
      '国内顺丰' => :shunfeng,
      '国内申通' => :shentong,
      '国内圆通' => :yuantong,
      'DHL中国件' => :dhl,
      'DHL英文' => :dhlen,
      'BorderGuru' => :borderguru
    }
  end

  def logistic_partners
    {
      'Beihai' => :beihai,
      'MKPost' => :mkpost,
      'Manual' => :manual
    }
  end

  def orders_status
    {
      'New' => :new,
      'Paying' => :paying,
      'Payment Unverified' => :unverified,
      'Payment failed' => :failed,
      'Cancelled' => :cancelled,
      'Paid' => :paid,
      'Shipped' => :shipped,
      'Terminated' => :terminated
    }
  end

  def order_payments_status
    {
      'Scheduled' => :scheduled,
      'Unverified' => :unverified,
      'Success' => :success,
      'Failed' => :failed,
    }
  end
end
