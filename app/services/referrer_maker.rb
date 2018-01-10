class ReferrerMaker < BaseService
  # time limit will be taken into consideration only
  # if the group_token is not defined
  TIME_LIMIT = -> { 24.hours.ago }

  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def convert!(group_token: nil, time_limit: true)
    turn_to_referrer!(time_limit, group_token)
    assign_to_group!(group_token)
    assign_itself_as_referrer!
    generate_coupon!
    return_with(:success)
  rescue ReferrerMaker::Error => exception
    return_with(:error, exception.message)
  end

  private

    def assign_itself_as_referrer!
      customer.update(parent_referrer: customer.referrer)
    end

    def turn_to_referrer!(time_limit, group_token)
      customer.reload
      unless customer.referrer
        raise ReferrerMaker::Error, 'Customer can\'t be turned into referrer after 24 hours creation' if (!recent_customer? && time_limit) && !group_token
        Referrer.create(user: customer)
      end
    end

    def recent_customer?
      customer.c_at >= TIME_LIMIT.call
    end

    def assign_to_group!(token)
      # we assign the referrer token if needed
      referrer_group = ReferrerGroup.where(token: token).first
      customer.referrer.update(referrer_group: referrer_group) if referrer_group
    end

    def generate_coupon!
      # we create the first coupon if needed (after the token because it can change data)
      PrebuiltCoupon.referrer_coupon(customer.referrer)
    end
end
