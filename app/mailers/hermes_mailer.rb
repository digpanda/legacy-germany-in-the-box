class HermesMailer < ApplicationMailer
  
   default from: 'hermes@germanyinthebox.com'
   layout 'mailers/hermes'
 
  def notify(shop_email, data, csv)
    @data = data
    attachments['orders.csv'] = csv
    mail(
         to: "operations.ecommerce@hermesworld.com", 
         cc: ["operations@borderguru.com", shop_email],
         subject: "Merchant PickUp Hermes" # to define
         )
  end

end
