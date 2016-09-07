class HermesMailer < ApplicationMailer

   default from: 'hermes@germanyinthebox.com'
   layout 'mailers/hermes'

  def notify(shopkeeper_id, data, csv)
    shop = User.find(shopkeeper_id).shop
    @data = data
    attachments['orders.csv'] = csv
    mail(
         to: "operations.ecommerce@hermesworld.com",
         cc: ["merchant@borderguru.com", shopkeeper.email, "shop@germanyinthebox.com"],
         subject: "Pickup Avisierung: #{shop.bg_merchant_id}, #{shop.lname}, #{Time.now.utc.strftime("%Y-%m-%d")}"
         )
  end

end
