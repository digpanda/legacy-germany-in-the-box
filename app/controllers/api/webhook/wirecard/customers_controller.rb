require 'cgi'

# Get notifications from Wirecard when a transaction has been done
class Api::Webhook::Wirecard::CustomersController < Api::ApplicationController

  skip_before_filter :verify_authenticity_token

  WIRECARD_CONFIG = Rails.application.config.wirecard
  REQUEST_ID_TRIM = %w(-check-enrollment)

  # country=CN&merchant_account_resolver_category=&response_signature=25bc1e774bb38a1fc6660857bdc3f4b708fbdb0e08680f0a5e26eac81e5981dc&city=%E5%8E%BF&group_transaction_id=&provider_status_code_1=&locale=zh_CN&requested_amount=717.28&completion_time_stamp=20160913133720&provider_status_description_1=&token_id=4304509873471003&authorization_code=981517&merchant_account_id=9105bb4f-ae68-4768-9c3b-3eda968f57ea&provider_transaction_reference_id=&state=%E5%A4%A9%E6%B4%A5%E5%B8%82&first_name=jlk&email=customer17%40customer.com&transaction_id=630560ba-76c7-4e7b-ace8-ab0bf815a33a&provider_transaction_id_1=&status_severity_1=information&last_name=jlkjl&ip_address=127.0.0.1&transaction_type=purchase&status_code_1=201.0000&masked_account_number=401200******1003&status_description_1=3d-acquirer%3AThe+resource+was+successfully+created.&phone=%280856%29+856405495&transaction_state=success&requested_amount_currency=CNY&postal_code=300222&request_id=67f6865e-6cd7-4adb-92b5-fffdfdaba815&
  #

  def create

    devlog.info "Wirecard started to communicate with us ..."
    devlog.info("Raw datas : #{datas}")

    if wrong_datas?
        throw_api_error(:bad_format, {error: "Wrong datas transmitted"}, :bad_request)
      return
    end

    devlog.info "Service received `#{datas[:request_id]}`, `#{datas[:merchant_account_id]}`, `#{datas[:reseller_id]}`"

    # we get the important datas
    # customer_email = datas[:email].first
    # transaction_id = datas[:transaction_id].first
    devlog.info "We will update the order payment ..."
    checker = payment_checker.update_order_payment!
    devlog.info "Order payment was refreshed."
    # it doesn't matter if the API call failed, the order has to be systematically up to date with the order payment in case it's not already sent
    devlog.info "We synchronize the order status depending on the refreshed payment one ..."
    order_payment.order.refresh_status_from!(order_payment)
    if checker.success?
      devlog.info "The order was refreshed and seem to be paid."
    else
      devlog.info "The order was refreshed but don't seem to be paid. (#{checker.error})"
    end
    devlog.info "End of process."
    render status: :ok,
            json: {success: true}.to_json

  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wirecard_customers_webhook.log"))
  end

  private

  def datas
    @datas ||= CGI.parse(request.body.read).deep_symbolize_keys
  end

  def wrong_datas?
    datas[:merchant_account_id].nil? || datas[:request_id].nil?
  end

  def order_payment
    @order_payment ||= OrderPayment.where({merchant_id: merchant_id, request_id: request_id}).first
  end

  # make API call which refresh order payment
  def payment_checker
    @payment_checker ||= WirecardPaymentChecker.new({:order_payment => order_payment})
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

  def merchant_id
    unless datas[:merchant_account_id].nil?
      datas[:merchant_account_id].first
    end
  end

end
