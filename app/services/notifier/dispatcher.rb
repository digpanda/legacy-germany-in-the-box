# emit a notification and set the correct model
# then dispatch the notification to the user email / sms
# or whatever mode
class Notifier
  class Dispatcher < BaseService

    attr_reader :email, :user, :title, :desc, :url

    def initialize(email:nil,user:nil,title:nil,desc:nil,url:nil)
      @email = email
      @user = user
      @title = title
      @desc = desc
      @url = url
    end

    def perform(dispatch:[:email])
      db! if user
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
