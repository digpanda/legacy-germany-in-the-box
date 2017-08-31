# emit a notification and set the correct model
# then dispatch the notification to the user email / sms
# or whatever mode
class Notifier
  class Dispatcher < BaseService

    attr_reader :email, :mobile, :mailer, :user, :unique_id, :title, :desc, :url, :scope, :metadata

    def initialize(email:nil,mobile:nil,mailer:nil,user:nil,unique_id:nil,title:nil,desc:nil,url:nil,scope:nil,metadata:nil)
      @email = email
      @mobile = mobile
      @mailer = mailer
      @user = user
      @unique_id = unique_id
      @title = title
      @desc = desc
      @url = url
      @scope = scope
      @metadata = metadata
    end

    def perform(dispatch:[:email])
      db! # if user <-- why limit to user ?
      email! if dispatch.include? :email
      sms! if dispatch.include? :sms
      return_with(:success)
    rescue Notifier::Error => exception
      return_with(:error, exception.message)
    end

    def db!
      Db.new(self).perform
    end

    def email!
      Email.new(self).perform
    end

    def sms!
      Sms.new(self).perform
    end

  end
end
