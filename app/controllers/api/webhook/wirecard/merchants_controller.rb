#
# Webhook communication with Wirecard.
# Any communication with Wirecard from server to server linked to the merchant / shopkeeper
# Such as `wirecard_status` to activate their payment account is under this controller.
#
class Api::Webhook::Wirecard::MerchantsController < ApplicationController

  attr_reader :wirecard_config, :errors_config, :datas

  load_and_authorize_resource :class => User

  before_action :load_configs
  before_action :validate_merchant_datas

  def load_configs
    @wirecard_config = Rails.application.config.wirecard
    @errors_config = Rails.application.config.errors
  end

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
    devlog.info "Service received `#{datas[:merchant_id]}`, `#{atas[:merchant_status]}`, `#{datas[:reseller_id]}`" 

    unless authenticate_resource(datas[:reseller_id])
      render status: :unauthorized, 
             json: throw_error(:bad_credentials).to_json and return
    end
    devlog.info "It passed the authentication"

    shop = Shop.where(id: datas[:merchant_id]).first
    if shop.nil?
      render status: :unprocessable_entity, 
             json: throw_error(:unknown_id).merge(error: "Unknown merchant id.").to_json and return
    end

    shop.wirecard_status = atas[:merchant_status].downcase
    unless shop.save
      render status: :bad_request,
             json: throw_error(:fail_validation).merge(error: shop.errors.full_messages.join(', ')).to_json and return
    end

    devlog.info "System is done."
    render status: :ok, 
           json: {success: true}.to_json and return

  end

  private

  def authenticate_resource(reseller_id)
    reseller_id == wirecard_config[:merchants][:reseller_id]
  end

  def required_merchant_datas

    devlog.info "We try to handle the `postback` data"
    return false if params["postback"].nil?

    @datas = process_postback(params["postback"])
    devlog.info "Parameters : #{output_hash(datas)}"

    datas[:merchant_id].present? && datas[:merchant_status].present? && datas[:reseller_id].present?

  end

  def output_hash(hash)
    hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end

  def process_postback(postback)
    ActiveSupport::JSON.decode(postback.gsub('\\"', '')).symbolize_keys
  end

  def validate_merchant_datas
    render status: :bad_request, 
           json: throw_error(:bad_format).to_json and return if !required_merchant_datas
  end

  def throw_error(sym)
    devlog.info errors_config[sym][:error]
    {success: false}.merge(errors_config[sym])
  end

  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wirecard_webhook.log"))
  end

end