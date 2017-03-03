class CheckoutCallback < BaseService

  attr_reader :user, :params, :forced_status

  def initialize(user, params, forced_status=nil)
    @user = user
    @params = params
    @forced_status = forced_status
  end

  def wirecard!
    SlackDispatcher.new.message("`#{user.email}` == `#{params['email']}` ?")
    if user.email != params["email"]
      return return_with(:error, I18n.t(:account_conflict, scope: :notice))
    end

    order_payment = solve_wirecard_order_payment_and_refresh!
    dispatch_notifications!(order_payment)

    return_with(:success)
  end

  # def alipay!
  #   binding.pry
  # end

  private

  def solve_wirecard_order_payment_and_refresh!
    OrderPayment.where({merchant_id: params["merchant_account_id"], request_id: params["request_id"]}).first.tap do |order_payment|
      # we check WireCard API which makes it safe
      # so we can change the status itself
      # NOTE : we shouldn't do it for anything else
      WirecardPaymentChecker.new(params.symbolize_keys.merge({:order_payment => order_payment})).update_order_payment!
      order_payment.status = forced_status if forced_status
      order_payment.save
      order_payment.order.refresh_status_from!(order_payment)
    end
  end

  def dispatch_notifications!(order_payment)
    if order_payment.status == :success
      SlackDispatcher.new.paid_transaction(order_payment)

      DispatchNotification.new.perform_if_not_sent({
        order: order_payment.order,
        user: order_payment.order.shop.shopkeeper,
        title: "Auftrag #{order_payment.order.id} am #{order_payment.order.paid_at}",
        desc: 'Haben Sie die Bestellung schon vorbereiten? Senden Sie die bitte!'
        })
      DispatchNotification.new.perform_if_not_selected_sent({
        order: order_payment.order,
        user: order_payment.order.shop.shopkeeper,
        title: "Auftrag #{order_payment.order.id} am #{order_payment.order.paid_at}",
        desc: "Haben Sie die Bestellung schon gesendet? Klicken Sie bitte 'Das Paket wurde versandt'"
        })

    else
      SlackDispatcher.new.failed_transaction(order_payment)
    end
  end



end
