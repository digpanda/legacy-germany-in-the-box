class CustomerMailer < ApplicationMailer

   default from: 'notifications@germanyinthebox.com'
   layout 'mailers/customer'

  def notify(user_id, title, url)
    @user = User.find(user_id)
    @title = title
    @url = url
    mail(to: @user.email, subject: "通知 : #{@title}") # @user.email
  end

end
