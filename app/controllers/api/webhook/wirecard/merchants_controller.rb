#
# Webhook communication with Wirecard.
# Any communication with Wirecard from server to server linked to the merchant / shopkeeper
# Such as `wirecard_status` to activate their payment account is under this controller.
#
class Api::Webhook::Wirecard::MerchantsController < Api::ApplicationController

  attr_reader :datas

  load_and_authorize_resource :class => User
  before_action :validate_remote_server_request

  #
  # Wirecard don't respect a RESTful scheme. The `create` method is currently used
  # To update the merchant / shopkeeper `wirecard_status`
  # The system is nonetheless flexible and ready for this kind of change, easily.
  #
  def create
    update
  end

  def update

    devlog.info "Wirecard started to communicate with our system" 
    devlog.info "Service received `#{datas[:merchant_id]}`, `#{datas[:merchant_status]}`, `#{datas[:reseller_id]}`" 

    unless authenticated_resource?(datas[:reseller_id])
      render status: :unauthorized, 
             json: throw_error(:bad_credentials).to_json and return
    end
    devlog.info "It passed the authentication"

    shop = Shop.where(id: datas[:merchant_id]).first
    if shop.nil?
      render status: :unprocessable_entity, 
             json: throw_error(:unknown_id).merge(error: "Unknown merchant id.").to_json and return
    end
    devlog.info "It passed the merchant recognition."

    shop.wirecard_status = clean_merchant_status

    if shop.wirecard_status == :active
      credentials = datas[:wirecard_credentials]
      shop.wirecard_ee_user_cc = credentials[:ee_user_cc]
      shop.wirecard_ee_password_cc = credentials[:ee_password_cc]
      shop.wirecard_ee_secret_cc = credentials[:ee_secret_cc]
      shop.wirecard_ee_maid_cc = credentials[:ee_maid_cc]
    end

    unless shop.save
      render status: :bad_request,
             json: throw_error(:wrong_update_attributes).merge(error: shop.errors.full_messages.join(', ')).to_json and return
    end

    devlog.info "End of process."
    render status: :ok, 
           json: {success: true}.to_json and return

  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wirecard_webhook.log"))
  end

  private

  def authenticated_resource?(reseller_id)
    reseller_id == wirecard_config[:merchants][:reseller_id]
  end

  def required_merchant_datas

    devlog.info "We try to handle the `postback` data"
    return false if params["postback"].nil?

    @datas = process_postback(params["postback"])
    devlog.info "Parameters : #{output_hash(datas)}"

    return false unless datas[:merchant_id].present? && datas[:merchant_status].present? && datas[:reseller_id].present?
    return false if clean_merchant_status == :active && datas[:wirecard_credentials].present? == false
    return true

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
    render status: :bad_request, 
           json: throw_error(:bad_format).to_json and return if !required_merchant_datas
  end

end