class ShopkeeperMailer < ApplicationMailer

   default from: 'no-reply@germanyinthebox.com'
   layout 'mailers/shopkeeper'

  def notify(user_id, title, url)
    @user = User.find(user_id)
    @title = title
    @url = url
    mail(to: @user.email, subject: "Benachrichtigung von Germany In The Box: #{@title}") # @user.email
  end

end
