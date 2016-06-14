class UserMailer < ApplicationMailer
   default from: 'notifications@germanyinthebox.com'
 
  def notify(user, title, url)
    @user = user
    @title = title
    @url = url
    mail(to: @user.email, subject: "Notification : #{@title}") # @user.email
  end

end
