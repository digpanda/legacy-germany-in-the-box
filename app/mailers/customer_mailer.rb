class CustomerMailer < ApplicationMailer

   default from: 'no-reply@germanyinthebox.com'
   layout 'mailers/customer'

  def notify(user_id, title, url)
    @user = User.find(user_id)
    @title = title
    @url = url
    mail(to: @user.email, subject: "来因盒通知: #{@title}") # @user.email
  end

end
