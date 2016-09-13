require 'cgi'

# Get notifications from Wirecard when a transaction has been done
class Api::Webhook::Wirecard::CustomersController < Api::ApplicationController

  skip_before_filter :verify_authenticity_token

  REQUEST_ID_TRIM = %w(-check-enrollment)


  # country=CN&merchant_account_resolver_category=&response_signature=25bc1e774bb38a1fc6660857bdc3f4b708fbdb0e08680f0a5e26eac81e5981dc&city=%E5%8E%BF&group_transaction_id=&provider_status_code_1=&locale=zh_CN&requested_amount=717.28&completion_time_stamp=20160913133720&provider_status_description_1=&token_id=4304509873471003&authorization_code=981517&merchant_account_id=9105bb4f-ae68-4768-9c3b-3eda968f57ea&provider_transaction_reference_id=&state=%E5%A4%A9%E6%B4%A5%E5%B8%82&first_name=jlk&email=customer17%40customer.com&transaction_id=630560ba-76c7-4e7b-ace8-ab0bf815a33a&provider_transaction_id_1=&status_severity_1=information&last_name=jlkjl&ip_address=127.0.0.1&transaction_type=purchase&status_code_1=201.0000&masked_account_number=401200******1003&status_description_1=3d-acquirer%3AThe+resource+was+successfully+created.&phone=%280856%29+856405495&transaction_state=success&requested_amount_currency=CNY&postal_code=300222&request_id=67f6865e-6cd7-4adb-92b5-fffdfdaba815&
  #

  WIRECARD_CONFIG = Rails.application.config.wirecard

  def create

    # we get the important datas
    # customer_email = datas[:email].first
    merchant_id = datas[:merchant_account_id].first
    transaction_id = datas[:transaction_id].first

    # COPIES FROM HERE <-- we should avoid duplication
    order_payment = OrderPayment.where({merchant_id: merchant_id, request_id: request_id}).first
    WirecardPaymentChecker.new({transaction_id: transaction_id}.merge({:order_payment => order_payment})).update_order_payment!

    order_payment.status = forced_status unless forced_status.nil? # TODO : improve this
    order_payment.save

    if order_payment.status == :success
      SlackDispatcher.new.paid_transaction(order_payment)
    else
      SlackDispatcher.new.failed_transaction(order_payment)
    end

    # if it's a success, it paid
    # we freeze the status to unverified for security reason
    # and the payment status freeze on unverified
    order_payment.order.refresh_status_from!(order_payment)
    # END OF COPY

    # we update the linked payment without considering the callback itself
    # because we already have a system to do this kind of things
    # we will use all the datas available.
=begin    WirecardPaymentChecker.new({

      :order_payment => order_payment,
      :transaction_id => transaction_id,
      :merchant_account_id => merchant_account_id,

      }).update_order_payment!
=end
    devlog.info "End of process."
    render status: :ok,
            json: {success: true}.to_json and return

  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wirecard_customers_webhook.log"))
  end

  def datas
    @datas ||= CGI.parse(request.body.read).deep_symbolize_keys
  end

  def request_id
    @request_id ||= begin
      raw_request_id = datas[:request_id].first
      REQUEST_ID_TRIM.each do |trim_pattern|
        raw_request_id.gsub!(trim_pattern, "")
      end
      raw_request_id
    end
  end

end
