class ReferrerMaker < BaseService

  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def convert!(group_token:nil, time_limit:true)
    turn_to_referrer!(time_limit)
    assign_to_group!(group_token)
    generate_coupon!
    return_with(:success)
  rescue ReferrerMaker::Error => exception
    return_with(:error, exception.message)
  end

  private

  def turn_to_referrer!(time_limit)
    unless customer.referrer
      raise ReferrerMaker::Error, "Customer can't be turned into referrer after 24 hours creation" if !recent_customer? && time_limit
      Referrer.create(user: customer)
    end
  end

  def recent_customer?
    customer.c_at >= 24.hours.ago
  end

  def assign_to_group!(token)
    # we assign the referrer token if needed
    referrer_group = ReferrerGroup.where(token: token).first
    customer.referrer.update(referrer_group: referrer_group) if referrer_group
  end

  def generate_coupon!
    # we create the first coupon if needed (after the token because it can change data)
    Coupon.create_referrer_coupon(customer.referrer) if customer.referrer.coupons.empty?
  end

end
