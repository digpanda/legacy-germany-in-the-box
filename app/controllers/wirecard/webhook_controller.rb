class Wirecard::WebhookController < ApplicationController

  def devlog

    @@devlog ||= Logger.new("#{::Rails.root}/log/wirecard_webhook.log")

  end

  def merchant_status_change

    devlog.info("Wirecard started to communicate with our system")

    merchant_id = params["merchant_id"]
    merchant_status = params["merchant_status"]
    reseller_id = params["reseller_id"]

    devlog.info("Service received `#{merchant_id}`, `#{merchant_status}`, `#{reseller_id}`")

    shop = Shop.find(merchant_id)
    shop.wirecard_status = merchant_status
    shop.save

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

end
