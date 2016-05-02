class Wirecard::WebhookController < ApplicationController

  def merchant_status_change

=begin
  {
  "merchant_id": "<id>",
  "merchant_status": "<status>", //PROCESSING
  "reseller_id": "<hash>"
  }
=end

    binding.pry

  end

end
