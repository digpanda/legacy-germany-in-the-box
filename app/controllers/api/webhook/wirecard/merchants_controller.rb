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
  # The system is nonetheless flexible and ready for this kind of change.
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
    if (reseller_id == ::Rails.application.config.wirecard[:merchants][:reseller_id])

      devlog.info "It passed the authentication"

      shop = Shop.find(merchant_id)
      
      if shop.nil?
        devlog.info "Unknown merchant id."
        render status: 500, json: {success: false, error: "Unknown merchant id."}.to_json and return
      end

      shop.wirecard_status = merchant_status.downcase
      shop.save

      devlog.info "System is done."
      render status: 200, json: {success: true}.to_json and return

    end

    devlog.info "Bad credentials."
    render status: 500, json: {success: false, error: "Bad credentials."}.to_json and return

  end

  private

  def required_merchant_datas

    devlog.info "We try to handle the postback data"
    return false if params["postback"].nil?

    json_body = params["postback"].gsub('\\"', '') #params["postback"].gsub('\\', '')
    @datas = ActiveSupport::JSON.decode(json_body)
    devlog.info "Checking parameters ..."
    devlog.info "JSON : #{datas.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}"

    !!(datas["merchant_id"].present? && 
       datas["merchant_status"].present? && 
       datas["reseller_id"].present?)

  end

  def validate_merchant_datas
    devlog.info "Bad arguments."
    render status: 500, json: {success: false, error: "Bad arguments."}.to_json and return if !required_merchant_datas
  end

  def devlog
    @@devlog ||= Logger.new("#{::Rails.root}/log/wirecard_webhook.log")
  end

end