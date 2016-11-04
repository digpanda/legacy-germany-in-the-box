# manage the expenses and check if it reaches any limit
# there a some cases involving this service
# - the user wants to buy more than 1000 YUAN in one order and it has more than 1 item in it
# - the user select an address matching with an ID which has already spent too much today
class BuyingBreaker < BaseService

  def initialize
  end

  def reach_order_limit?(order)
  end

  def reach_customer_limit?(order)
  end
  
end
