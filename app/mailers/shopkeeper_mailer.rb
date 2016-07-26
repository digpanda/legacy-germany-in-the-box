class ShopkeeperMailer < ApplicationMailer
  
   default from: 'notifications@germanyinthebox.com'
   layout 'mailers/shopkeeper'
 
  def notify(user, title, url)
    @user = user
    @title = title
    @url = url
    mail(to: @user.email, subject: "Benachrichtigung: #{@title}") # @user.email
  end

end
