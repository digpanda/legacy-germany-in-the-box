class CheckoutCallback < BaseService

  # attr_reader :params, :forced_status
  #
  # def initialize(params, forced_status)
  #   @params = params
  #   @forced_status = status
  # end
  #
  # def perform
  #   return wirecard! if wirecard_callback?
  # end
  #
  # def alipay
  # end
  #
  # def wirecard!
  #   if current_user.email != params["email"]
  #     return return_with(:error, I18n.t(:account_conflict, scope: :notice))
  #   end
  #
  #   solve_order_payment_and_refresh!
  #
  #   if order_payment.status == :success
  #     SlackDispatcher.new.paid_transaction(order_payment)
  #     prepare_notifications(order_payment)
  #   else
  #     SlackDispatcher.new.failed_transaction(order_payment)
  #   end
  #
  #   return_with(:success)
  # end
  #
  # private
  #
  # def solve_order_payment_and_refresh!
  #   # COPIES FROM HERE
  #   order_payment = OrderPayment.where({merchant_id: params["merchant_account_id"], request_id: params["request_id"]}).first
  #   WirecardPaymentChecker.new(params.symbolize_keys.merge({:order_payment => order_payment})).update_order_payment!
  #
  #   order_payment.status = forced_status if forced_status
  #   order_payment.save
  #
  #   # if it's a success, it paid
  #   # we freeze the status to unverified for security reason
  #   # and the payment status freeze on unverified
  #   order_payment.order.refresh_status_from!(order_payment)
  #   # END OF COPY
  # end
  #
  # def wirecard_callback?
  #   params["email"] && params["merchant_account_id"] && params["request_id"]
  # end
  #
  # def prepare_notifications(order_payment)
  #   order = order_payment.order
  #   DispatchNotification.new.perform_if_not_sent({
  #                                                                 order: order,
  #                                                                 user: order.shop.shopkeeper,
  #                                                                 title: "Auftrag #{order.id} am #{order.paid_at}",
  #                                                                 desc: 'Haben Sie die Bestellung schon vorbereiten? Senden Sie die bitte!'
  #                                                             })
  #   DispatchNotification.new.perform_if_not_selected_sent({
  #                                                                          order: order,
  #                                                                          user: order.shop.shopkeeper,
  #                                                                          title: "Auftrag #{order.id} am #{order.paid_at}",
  #                                                                          desc: "Haben Sie die Bestellung schon gesendet? Klicken Sie bitte 'Das Paket wurde versandt'"
  #                                                                      })
  # end


end
