class CustomerMailer < ApplicationMailer
  default from: 'no-reply@germanyinthebox.com'
  layout 'mailers/customer'

  def notify(recipient_email:, user_id:, title:, url:)
    @recipient_email = recipient_email
    @user = User.where(id: user_id).first
    @title = title
    @url = url
    mail to: @recipient_email, subject: "来因盒通知: #{@title}"
  end
end
