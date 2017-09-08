class TrackingHandler < BaseService
  attr_reader :order_tracking

  CACHE = -> { 1.hour.ago }

  def initialize(order_tracking)
    @order_tracking = order_tracking
  end

  def refresh!
    unless cache_timeout?
      return return_with(:success)
    end

    unless api_performed.success?
      return return_with(:error, api_performed.error)
    end

    if update_order_tracking!
      return return_with(:success)
    else
      return return_with(:error, order_tracking.errors.full_messages.join(', '))
    end
  end

  def api_gateway
    @api_gateway ||= KuaidiApi.new(tracking_id: order_tracking.delivery_id, logistic_partner: logistic_partner)
  end

  private

  def cache_timeout?
    return true unless order_tracking.refreshed_at
    order_tracking.refreshed_at < CACHE.call
  end

  def update_order_tracking!
    order_tracking.update(
      state: api_performed.data[:current_state],
      histories: api_performed.data[:current_history],
      refreshed_at: Time.now
    )
  end

  def api_performed
    @api_performed ||= api_gateway.perform!
  end


  # BIG NOTE : LOGISTIC PARTNER IS HARDCODED AS MKPOST, WE NEED TO CHANGE THAT AFTER (it has to depend on the order)
  def logistic_partner
    :mkpost # order.logistic_partner
  end

  def order
    @order ||= order_tracking.order
  end

end
