class CustomerMailer < ApplicationMailer

  default from: 'no-reply@germanyinthebox.com'
  layout 'mailers/customer'

  def notify(email:, user_id:, title:, url:)
    @email = email
    @user = User.where(id: user_id).first
    @title = title
    @url = url
    mail(to: @email, subject: "来因盒通知: #{@title}")
  end

end
