class PhoneMessenger

  attr_reader :account_sid, :auth_token, :client, :from

  def initialize
    @account_sid = ENV['twilio_account_sid']
    @auth_token = ENV['twilio_auth_token']
    @from = ENV['twilio_from_number']
  end

  def send(to, body)
    client.account.messages.create(:body => body, :to => to, :from => from)
  end

  def client
    @client ||= Twilio::REST::Client.new account_sid, auth_token
  end

end
