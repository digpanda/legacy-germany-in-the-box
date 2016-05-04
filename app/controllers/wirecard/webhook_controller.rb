class Wirecard::WebhookController < ApplicationController

  # no authentication required
  before_action :authenticate_user!, except: [:merchant_status_change]
  acts_as_token_authentication_handler_for User, except: [:merchant_status_change]

  before_action :validate_merchant_datas

  # note : i made it fast, we should refacto and put some of this in libraries. - Laurent
  def merchant_status_change

    devlog.info "Wirecard started to communicate with our system" 

    merchant_id = params["merchant_id"]
    merchant_status = params["merchant_status"]
    reseller_id = params["reseller_id"]
    wirecard_credentials = params["wirecard_credentials"]
    
    devlog.info "Service received `#{merchant_id}`, `#{merchant_status}`, `#{reseller_id}`" 

    # we authenticate the source
    if (wirecard_credentials["ee_user_cc"] == ::Rails.application.config.wirecard["reseller"]["username"]) &&
       (wirecard_credentials["ee_password_cc"] == ::Rails.application.config.wirecard["reseller"]["password"])

      devlog.info "It passed the authentication"

      shop = Shop.find(merchant_id)

      shop.wirecard_status = merchant_status.downcase
      shop.save

      render text: "Ok" and return

    end
    
    render text: "Not ok" and return

  end

  private

  def required_merchant_datas
    !!(params["merchant_id"].present? && 
       params["merchant_status"].present? && 
       params["reseller_id"].present? &&
       params["wirecard_credentials"].present? && Hash === params["wirecard_credentials"])
  end

  def validate_merchant_datas
    render text: "Wrong arguments given." and return if !required_merchant_datas
  end

  def devlog
    @@devlog ||= Logger.new("#{::Rails.root}/log/wirecard_webhook.log")
  end


=begin

 
                    Array
(
    [merchant_id] => digpanda merchant id
    [merchant_status] => ACTIVE
    [reseller_id] => nba81H29Gba
    [wirecard_credentials] => Array
        (
            [ee_user_cc] => engine.digpanda
            [ee_password_cc] => x3Zyr8MaY7TDxj6F
            [ee_secret_cc] => 6cbfa34e-91a7-421a-8dde-069fc0f5e0b8
            [ee_maid_cc] => dfc3a296-3faf-4a1d-a075-f72f1b67dd2a
        )
)

=end

end
