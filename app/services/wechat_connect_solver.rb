# connect the customer from wechat omniauth system
class WechatConnectSolver < BaseService

  attr_reader :auth_data

  def initialize(auth_data)
    SlackDispatcher.new.message("WECHAT CONNECT SOLVER IS CALLED")
    @auth_data = auth_data
  end

  # we will resolve the wechat connection
  # we try to recover the customer matching the `auth_data`
  # or create a new one with the wechat informations
  def resolve!
    if customer.persisted?
      ensure_avatar!
      return_with(:success, :customer => customer)
    else
      return_with(:error, "Could not create customer.")
    end
  end

  private

  # make sure the customer has an avatar
  # else we use one from the auth_data
  def ensure_avatar!
    unless customer.pic.present?
      customer.remote_pic_url = avatar
      customer.save
    end
  end

  def customer
    @customer ||= existing_customer || new_customer
  end

  def existing_customer
    User.where(provider: auth_data.provider, wechat_unionid: auth_data.info.unionid).first
  end

  def new_customer
    User.create({
      :provider => auth_data.provider,
      :nickname => auth_data.info.nickname,
      :remote_pic_url => avatar,
      :email => "#{auth_data.info.unionid}@wechat.com",
      :role => :customer,
      :gender => gender,
      :password => random_password,
      :password_confirmation => random_password,
      :wechat_unionid => auth_data.info.unionid # what is it for ?
    })
  end

  def avatar
    auth_data.info.headimgurl
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
