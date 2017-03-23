require 'cgi'

# Get notifications from Wechatpay when a transaction has been done
class Api::Webhook::Wechatpay::CustomersController < Api::ApplicationController

  skip_before_filter :verify_authenticity_token

  def create

    devlog.info "Wechatpay started to communicate with us ..."
    devlog.info("Raw params : #{data}")

    if wrong_data?
      throw_api_error(:bad_format, {error: "Wrong datas transmitted"}, :bad_request)
      return
    end

    if checkout_callback.success?
      devlog.info "Transaction successfully processed."
      SlackDispatcher.new.message("It worked #{params}")
    else
      devlog.info "Processing of the transaction failed."
      SlackDispatcher.new.message("It DID NOT WORK #{params}")
    end

    devlog.info "End of process."
    render status: :ok,
            json: {success: true}.to_json
  end

  def data
    @data ||= Hash.from_xml(request.body.read)["xml"]
  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wechatpay-customers-webhook-#{Time.now.strftime('%Y-%m-%d')}.log"))
  end

  private

  def checkout_callback
    @checkout_callback ||= CheckoutCallback.new(nil, cart_manager, data).wechatpay!
  end

  def wrong_data?
    data["out_trade_no"].nil? || data["transaction_id"].nil? || data["return_code"].nil?
  end

end
