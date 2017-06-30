class ReferrerMaker < BaseService

  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def convert!(group_token:nil)
    turn_to_referrer!
    assign_to_group!(group_token)
    generate_coupon!
    return_with(:success)
  end

  private

  def turn_to_referrer!
    # we make sure the user is turned into a referrer
    Referrer.create(user: customer) unless customer.referrer
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
