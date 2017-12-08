module IdentityHelper
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

  def german_browser?
    request.env['HTTP_ACCEPT_LANGUAGE'].to_s.include? '-DE'
  end

end
