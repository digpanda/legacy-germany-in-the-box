# connect the customer from wechat omniauth system
class WechatConnectSolver < BaseService

  attr_reader :auth_data

  def initialize(auth_data)
    @auth_data = auth_data
  end

  # we will resolve the wechat connection
  # we try to recover the customer matching the `auth_data`
  # or create a new one with the wechat informations
  def resolve!
    if customer.save
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

  def new_customer
    User.create({
      :provider => auth_data.provider,
      :uid => auth_data.uid,
      #:remote_pic_url => auth_data.info.headimgurl,
      :email => "#{auth_data.info.unionid}@wechat.com",
      :role => :customer,
      :gender => gender,
      :password => random_password,
      :password_confirmation => random_password,
      :wechat_unionid => auth_data.info.unionid # what is it for ?
    })
  end

  def gender
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
