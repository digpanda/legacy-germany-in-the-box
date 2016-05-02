class Wirecard::WebhookController < ApplicationController

  def devlog

    @@devlog ||= Logger.new("#{::Rails.root}/log/wirecard_webhook.log")

  end

  def merchant_status_change

    devlog.info("Wirecard started to communicate with our system")

    merchant_id = params[:merchant_id]
    merchant_status = params[:merchant_status]
    reseller_id = params[:reseller_id]

    devlog.info("Service received `#{merchant_id}`, `#{merchant_status}`, `#{reseller_id}`")

  end

end
