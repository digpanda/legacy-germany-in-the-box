class ShopkeeperMailer < ApplicationMailer

   default from: 'notifications@germanyinthebox.com'
   layout 'mailers/shopkeeper'

  def notify(user_id, title, url)
    @user = User.find(user_id)
    @title = title
    @url = url
    mail(to: @user.email, subject: "Benachrichtigung: #{@title}") # @user.email
  end

end
