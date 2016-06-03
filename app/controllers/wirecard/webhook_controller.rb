class Wirecard::WebhookController < ApplicationController

  # no authentication required
  before_action :authenticate_user!, except: [:merchant_status_change]
  acts_as_token_authentication_handler_for User, except: [:merchant_status_change]

  before_action :validate_merchant_datas

  attr_reader :datas
  respond_to :json

  # NOTE
  # i made it fast, we should refacto and put some of this in libraries
  # and organize it within an /api/ folder
  # - Laurent
  def merchant_status_change

    devlog.info "Wirecard started to communicate with our system" 

    merchant_id = datas["merchant_id"]
    merchant_status = datas["merchant_status"]
    reseller_id = datas["reseller_id"]
    wirecard_credentials = datas["wirecard_credentials"]
    
    devlog.info "Service received `#{merchant_id}`, `#{merchant_status}`, `#{reseller_id}`" 

    # we authenticate the source
    if (wirecard_credentials["ee_user_cc"] == ::Rails.application.config.wirecard["reseller"]["username"]) &&
       (wirecard_credentials["ee_password_cc"] == ::Rails.application.config.wirecard["reseller"]["password"])

      devlog.info "It passed the authentication"

      shop = Shop.find(merchant_id)
      shop.wirecard_status = merchant_status.downcase
      shop.save

      devlog.info "System is done."

      render status: 200, json: {success: true}.to_json and return

    end
    
    render status: 500, json: {success: false}.to_json and return

  end

  private

  def required_merchant_datas

    devlog.info "We try to handle the postback data"
    return false if params["postback"].nil?

    json_body = params["postback"].gsub('\\', '')
    @datas = ActiveSupport::JSON.decode(json_body)
    #@datas = ActiveSupport::JSON.decode(request.body.read)

    devlog.info "Checking parameters ..."
    devlog.info "VARIABLES : #{params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}" 
    devlog.info "JSON : #{datas.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}"

    !!(datas["merchant_id"].present? && 
       datas["merchant_status"].present? && 
       datas["reseller_id"].present? &&
       datas["wirecard_credentials"].present? && Hash === datas["wirecard_credentials"])
  end

  def validate_merchant_datas
    render status: 500, json: {success: false, error: "Wrong arguments given."}.to_json and return if !required_merchant_datas
  end

  def devlog
    @@devlog ||= Logger.new("#{::Rails.root}/log/wirecard_webhook.log")
  end

end
