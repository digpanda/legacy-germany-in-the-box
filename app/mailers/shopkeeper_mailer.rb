class ShopkeeperMailer < ApplicationMailer

  default from: 'no-reply@germanyinthebox.com'
  layout 'mailers/shopkeeper'

  def notify(email:, user_id:, title:, url:)
    @email = email
    @user = User.where(id: user_id).first
    @title = title
    @url = url
    mail(to: @email, subject: "Benachrichtigung von Germany In The Box: #{@title}")
  end

end
