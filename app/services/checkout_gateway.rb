class CheckoutGateway < BaseService

  attr_reader :base_url, :user, :order, :payment_gateway

  def initialize(base_url, user, order, payment_gateway)
    @base_url = base_url
    @user = user
    @order = order
    @payment_gateway = payment_gateway
  end

  def wirecard
    return_with(:success, :checkout => wirecard_checkout)
  rescue Wirecard::Base::Error => exception
    return_with(:error, "An error occurred while processing the gateway (#{exception})")
  end

  def alipay
    return_with(:success, :url => "http://fuckit.com")
  # rescue Wirecard::Base::Error => exception
  #   return_with(:error, "An error occurred while processing the gateway (#{exception})")
  end

  private

  def wirecard_checkout
    @wirecard_checkout ||= WirecardCheckout.new(root_url, user, order, payment_gateway.payment_method).checkout!
  end

end
