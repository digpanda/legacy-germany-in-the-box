#
# Webhook communication with Wirecard.
# Any communication with Wirecard from server to server linked to the merchant / shopkeeper
# Such as `wirecard_status` to activate their payment account is under this controller.
#
class Api::Webhook::Wirecard::MerchantsController < ApplicationController

  load_and_authorize_resource :class => User
  before_action :validate_merchant_datas

  attr_reader :datas

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
    
    merchant_id     = datas["merchant_id"]
    merchant_status = datas["merchant_status"]
    reseller_id     = datas["reseller_id"]

    devlog.info "Service received `#{merchant_id}`, `#{merchant_status}`, `#{reseller_id}`" 

    # we authenticate the source
    if (reseller_id == Rails.application.config.wirecard[:merchants][:reseller_id])

      devlog.info "It passed the authentication"

      shop = Shop.where(id: merchant_id).first
      
      if shop.nil?
        devlog.info "Unknown merchant id."
        render status: :unprocessable_entity, json: {success: false, error: "Unknown merchant id."}.to_json and return
      end

      shop.wirecard_status = merchant_status.downcase
      shop.save

      if shop.save

        devlog.info "System is done."
        render status: :ok, json: {success: true}.to_json and return

      else

        devlog.info "Shop validation didn't pass (#{shop.errors.full_messages.join(', ')})"
        render status: :bad_request, json: {success: false, error: shop.errors.full_messages.join(', ')}.to_json and return

      end

    end

    devlog.info "Bad credentials."
    render status: :unauthorized, json: {success: false, error: "Bad credentials."}.to_json and return

  end

  private

  def required_merchant_datas

    devlog.info "We try to handle the postback data"
    return false if params["postback"].nil?

    @datas = process_postback(params["postback"])
    devlog.info "Checking parameters ..."
    devlog.info "JSON : #{output_hash(datas)}"

    datas["merchant_id"].present? && datas["merchant_status"].present? && datas["reseller_id"].present?

  end

  def output_hash(hash)
    hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end

  def process_postback(postback)
    ActiveSupport::JSON.decode(postback.gsub('\\"', ''))
  end

  def validate_merchant_datas
    devlog.info "Bad arguments."
    render status: :bad_request, json: {success: false, error: "Bad arguments."}.to_json and return if !required_merchant_datas
  end

  def devlog
    @@devlog ||= Logger.new("#{::Rails.root}/log/wirecard_webhook.log")
  end

end