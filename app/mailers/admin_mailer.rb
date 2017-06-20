class AdminMailer < ApplicationMailer

  default from: 'no-reply@germanyinthebox.com'
  layout 'mailers/admin'

  def notify(email:, user_id:, title:, url:)
    @email = email
    @user = User.where(id: user_id).first
    @title = title
    @url = url
    mail(to: @email, subject: "Notification : #{@title}")
  end

end
