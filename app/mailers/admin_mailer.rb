class AdminMailer < ApplicationMailer
  default from: 'no-reply@germanyinthebox.com'
  layout 'mailers/admin'

  def notify(recipient_email:, user_id:, title:, url:, desc:)
    @recipient_email = recipient_email
    @title = title
    @desc = desc
    @url = url
    mail to: @recipient_email, subject: "Notification : #{@title}"
  end
end
