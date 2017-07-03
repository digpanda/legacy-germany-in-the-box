class CheckoutGateway < BaseService

  ACCEPTABLE_PROVIDERS = [:alipay, :wechatpay]

  include Rails.application.routes.url_helpers
  attr_reader :request, :user, :order, :payment_gateway, :identity_solver

  def initialize(request, user, order, payment_gateway, identity_solver)
    @request = request
    @user = user
    @order = order
    @payment_gateway = payment_gateway
    @identity_solver = identity_solver
  end

  def perform
    return return_with(:error, "Provider not accepted.") unless acceptable_provider?
    return self.send(payment_gateway.provider)
  end

  def alipay
    return_with(:success, :url => alipay_checkout_url)
  end

  def wechatpay
    return_with(:success, :page => wechatpay_checkout)
  end

  private

  def acceptable_provider?
    ACCEPTABLE_PROVIDERS.include? payment_gateway.provider
  end

  def wechatpay_checkout
    @wechatpay_checkout_url ||= WechatpayGate.new(base_url, user, order, payment_gateway, identity_solver).checkout!
  end

  def alipay_checkout_url
    @alipay_checkout_url ||= AlipayGate.new(base_url, user, order, payment_gateway, identity_solver).checkout_url!
  end

  def base_url
    "#{request.protocol}#{request.host_with_port}/"
  end

end
