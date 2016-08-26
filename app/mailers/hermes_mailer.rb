class HermesMailer < ApplicationMailer

   default from: 'hermes@germanyinthebox.com'
   layout 'mailers/hermes'

  def notify(shopkeeper, data, csv)
    shop = shopkeeper.shop
    @data = data
    attachments['orders.csv'] = csv
    mail(
         to: "operations.ecommerce@hermesworld.com",
         cc: ["merchant@borderguru.com", shopkeeper.email, "shop@germanyinthebox.com"],
         subject: "Pickup Avisierung: #{shop.bg_merchant_id}, #{shopkeeper.lname}, DATE_OF_SENDING_THIS_EMAIL"
         )
  end

end
