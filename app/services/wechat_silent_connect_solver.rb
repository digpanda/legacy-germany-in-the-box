# connect the customer from wechat omniauth system
class WechatSilentConnectSolver < BaseService

  attr_reader :auth_data

  def initialize(auth_data)
    @auth_data = auth_data
  end

  # we will resolve the wechat connection
  # we try to recover the customer matching the `auth_data`
  # or create a new one with the wechat informations
  def resolve!
    if customer.persisted?
      ensure_avatar!
      return_with(:success, customer: customer)
    else
      return_with(:error, 'Could not create customer.')
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
    User.where(provider: 'wechat', wechat_unionid: auth_data['unionid']).first
  end

  def new_customer
    SlackDispatcher.new.silent_login_attempt('1. New user')
    user = User.new({
                    provider: 'wechat',
                    uid: auth_data['openid'],
                    referrer_nickname: auth_data['nickname'],
                    remote_pic_url: auth_data['headimgurl'],
                    email: "#{auth_data['unionid']}@wechat.com",
                    role: :customer,
                    gender: gender,
                    password: random_password,
                    password_confirmation: random_password,
                    wechat_unionid: auth_data['unionid']
                })
    SlackDispatcher.new.silent_login_attempt('2. Save user...')
    SlackDispatcher.new.silent_login_attempt("User info: uid=#{auth_data['openid']} email=#{auth_data['unionid']}@wechat.com unionid=#{auth_data['unionid']}")
    user.save
    SlackDispatcher.new.silent_login_attempt("Errors? = #{user.errors.full_messages.join(', ')}")
    user
  end

  def avatar
    auth_data['headimgurl']
  end

  def gender
   auth_data['sex'] == 1 ? 'm' : 'f'

  end

  def random_password
    @random_password ||= SecureRandom.uuid
  end
end
