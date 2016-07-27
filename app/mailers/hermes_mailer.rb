class HermesMailer < ApplicationMailer
  
   default from: 'hermes@germanyinthebox.com'
   layout 'mailers/hermes'
 
  def notify(shop_email, data, csv)
    @data = data
    @csv = csv
    mail(
         to: "operations.ecommerce@hermesworld.com", 
         cc: ["operations@borderguru.com", shop_email],
         add_file: {:filename => 'orders.csv', :content => csv},
         subject: "Merchant PickUp Hermes" # to define
         )
  end

end
