# webhook communication with Wirecard.
# any communication with Wirecard from server to server linked to the merchant / shopkeeper
# such as `wirecard_status` to activate their payment account is under this controller.
class Api::Webhook::Wirecard::MerchantsController < Api::ApplicationController

  WIRECARD_CONFIG = Rails.application.config.wirecard
  CREDENTIALS_PAYMENT_METHODS = {
    :creditcard => [:ee_maid_cc, :ee_secret_cc],
    :upop => [:ee_maid_cup, :ee_secret_cup],
    :paypal => [:ee_maid_paypal, :ee_secret_paypal]
  }

  attr_reader :datas

  before_action :validate_remote_server_request

  # wirecard don't respect a RESTful scheme. The `create` method is currently used
  # to update the merchant / shopkeeper `wirecard_status`
  # the system is nonetheless flexible and ready for this kind of change, easily.
  def create
    update
  end

  def update

    devlog.info "Wirecard started to communicate with our system"
    devlog.info "Service received `#{datas[:merchant_id]}`, `#{datas[:merchant_status]}`, `#{datas[:reseller_id]}`"

    throw_api_error(:bad_credentials, {}, :unauthorized) and return unless authenticated_resource?(datas[:reseller_id])

    devlog.info "It passed the authentication"

    shop = Shop.where(merchant_id: datas[:merchant_id]).first

    if shop.nil?
      throw_api_error(:unknown_id, {error: "Unknown merchant id."}, :unprocessable_entity)
      return
    end

    devlog.info "It passed the merchant recognition."

    shop.wirecard_status = clean_merchant_status

    if shop.wirecard_status == :active
      unless save_shop_wirecard_credentials!(shop, datas[:wirecard_credentials])
        throw_api_error(:bad_format, {error: "Credentials not recognized or not saved."}, :bad_request)
        return
      end
    end

    throw_api_error(:wrong_update_attributes, {error: shop.errors.full_messages.join(', ')}) and return unless shop.save

    devlog.info "End of process."
    render status: :ok,
           json: {success: true}.to_json and return

  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wirecard_merchants_webhook.log"))
  end

  private

  def matching_payment_method_scheme?(scheme, credentials)
    scheme.each do |field|
      return false if credentials[field].nil?
    end
    true
  end

  def processed_credentials(credentials)
    CREDENTIALS_PAYMENT_METHODS.each do |payment_method|
      if matching_payment_method_scheme?(payment_method.last, credentials)
        return {
          :payment_method => payment_method.first,
          :merchant_id => credentials[payment_method.last.first],
          :merchant_secret => credentials[payment_method.last.last],
        }
      end
    end
    false
  end

  # recognize the payment method from the type of fields we receive as credentials
  # process it and create a new payment gateway if needed
  # can update the current credentials for a specific payment method
  def save_shop_wirecard_credentials!(shop, credentials)
    processed = processed_credentials(credentials)
    if processed
      payment_gateway = matching_payment_gateway(shop, processed[:payment_method])
      payment_gateway.shop_id = shop.id
      payment_gateway.provider = :wirecard
      payment_gateway.payment_method = processed[:payment_method]
      payment_gateway.merchant_id = processed[:merchant_id]
      payment_gateway.merchant_secret = processed[:merchant_secret]
      payment_gateway.save
    else
      devlog.info "The payment method was not recognized. Please try again with correct credential fields."
      false
    end
  end

  def matching_payment_gateway(shop, payment_method)
    PaymentGateway.where(shop_id: shop.id, payment_method: payment_method).first || PaymentGateway.new
  end

  # check if there's a correct reseller id
  def authenticated_resource?(reseller_id)
    reseller_id == WIRECARD_CONFIG[:merchants][:reseller_id]
  end

  def required_merchant_datas
    devlog.info "We try to handle the `postback` data"
    return false if params["postback"].nil?
    @datas = process_postback(params["postback"])
    devlog.info "Parameters : #{output_hash(datas)}"

    basic_consistent_datas? && active_consistent_datas?
  end

  def basic_consistent_datas?
    datas[:merchant_id].present? && datas[:merchant_status].present? && datas[:reseller_id].present?
  end

  def active_consistent_datas?
    clean_merchant_status == :active ? datas[:wirecard_credentials].present? : true
  end

  def clean_merchant_status
    datas[:merchant_status].downcase.to_sym
  end

  def output_hash(hash)
    hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end

  def process_postback(postback)
    ActiveSupport::JSON.decode(postback.gsub('\\"', '')).deep_symbolize_keys
  end

  def validate_remote_server_request
    throw_api_error(:bad_format, {}, :bad_request) and return if !required_merchant_datas
  end

end
