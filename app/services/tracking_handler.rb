class TrackingHandler
  attr_reader :order

  # TODO : make a cache ?

  def initialize(order)
    @order = order
  end

  def refresh!
    if kuaidi_api.success?
      if update_order_tracking!
        return return_with(:success)
      else
        return return_with(:error, order_tracking.errors.full_messages.join(', '))
      end
    else
      return_with(:error, kuaidi_api.error)
    end
  end

  def update_order_tracking!
    order_tracking.update(
      state: kuaidi_api.data[:current_state],
      histories: kuaidi_api.data[:current_history],
      refreshed_at: Time.now
    )
  end

  # BIG NOTE : LOGISTIC PARTNER IS HARDCODED AS MKPOST, WE NEED TO CHANGE THAT AFTER (it has to depend on the order)
  def kuaidi_api
    @kuaidi_api ||= KuaidiApi.new(tracking_id: order_tracking.unique_id, logistic_partner: :mkpost).perform!
  end

  def order_tracking
    @order_tracking ||= order.order_tracking || OrderTracking.create(order: order)
  end

end
