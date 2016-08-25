class HermesMailer < ApplicationMailer

   default from: 'hermes@germanyinthebox.com'
   layout 'mailers/hermes'

  def notify(shop_email, data, csv)
    @data = data
    attachments['orders.csv'] = csv
    mail(
         to: "operations.ecommerce@hermesworld.com",
         cc: ["merchant@borderguru.com", shop_email, "shop@germanyinthebox.com"],
         subject: "Merchant PickUp Hermes"
         )
  end

end
