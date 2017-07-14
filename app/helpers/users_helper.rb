module UsersHelper

  def user_roles
    [['Administrator', :admin],['Shopkeeper', :shopkeeper],['Customer', :customer]]
  end

  def parent_referrers
    Referrer.all.reduce([]) do |acc, referrer|
      acc << ["#{referrer.user.decorate.full_name} (#{referrer.reference_id})", referrer.id]
    end
  end

  def potential_customer?
    identity_solver.potential_customer?
  end

  def potential_shopkeeper?
    identity_solver.potential_shopkeeper?
  end

  def potential_admin?
    identity_solver.potential_admin?
  end

  # put this into language ?
  def german?
    identity_solver.german?
  end

  def chinese?
    identity_solver.chinese?
  end

  def chinese_ip?
    identity_solver.chinese_ip?
  end

end
