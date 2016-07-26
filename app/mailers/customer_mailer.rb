class CustomerMailer < ApplicationMailer
  
   default from: 'notifications@germanyinthebox.com'
   layout 'mailers/customer'
 
  def notify(user, title, url)
    @user = user
    @title = title
    @url = url
    mail(to: @user.email, subject: "通知 : #{@title}") # @user.email
  end

end
