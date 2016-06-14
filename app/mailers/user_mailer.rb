class UserMailer < ApplicationMailer
   default from: 'notifications@germanyinthebox.com'
 
  def notify(user, title, url)
    @user = user
    @title = title
    @url = url
    mail(to: "laurent.schaffner@digpanda.com", subject: "Notification : #{@title}") # @user.email
  end

end
