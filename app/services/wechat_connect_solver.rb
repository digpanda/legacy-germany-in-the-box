class WechatConnectSolver < BaseService

  attr_reader :auth_data

  def initialize(auth_data)
    @auth_data = auth_data
  end

  def resolve!
    if customer.instance_of?(User)
      return_with(:success, :customer => customer)
    else
      return_with(:error, "Could not create customer.")
    end
  end

  private

  def customer
    @customer ||= existing_customer || new_customer
  end

  def existing_customer
    User.where(provider: auth_data.provider, uid: auth_data.uid).first
  end

  # TODO : improve the login and add the image of the user when it's the firs time he logs-in
  def new_customer
    User.create({
      :provider => auth_data.provider,
      :uid => auth_data.uid,
      :email => "#{auth_data.info.unionid}@wechat.com",
      :role => :customer,
      :gender => guess_sex,
      :password => random_password,
      :password_confirmation => random_password,
      :wechat_unionid => auth_data.info.unionid # what is it for ?
    })
  end

  def guess_sex
     if auth_data.info.sex == 1
       'm'
     else
       'f'
     end
  end

  def random_password
    @random_password ||= SecureRandom.uuid
  end

end
