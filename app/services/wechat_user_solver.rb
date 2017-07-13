# solve database user from wechat data
# those data can be provided from different origin
# such as Omniauth or API calls
class WechatUserSolver < BaseService

  attr_reader :unionid, :openid, :provider, :nickname, :avatar, :sex

  def initialize(provider:nil, unionid:nil, openid:nil, nickname:nil, avatar:nil, sex:nil)
    @provider = provider
    @unionid  = unionid
    @openid   = openid
    @nickname = nickname
    @avatar   = avatar
    @sex      = sex
  end

  # we will resolve the wechat connection
  # we try to recover the customer matching the data
  # or create a new one with the wechat informations
  def resolve!
    ensure_unionid!
    if customer.persisted?
      ensure_avatar!
      refresh_openid!
      return_with(:success, :customer => customer)
    else
      return_with(:error, "Could not create customer (#{customer.errors.full_messages.join(',')}).")
    end
  end

  private

  # make sure the customer has an avatar
  # else we use one from the data
  def ensure_avatar!
    unless customer.pic.present?
      customer.remote_pic_url = avatar
      customer.save
    end
  end

  def ensure_unionid!
    if openid && !unionid
      user_info = WechatApiUserInfo.new(openid).resolve!
      SlackDispatcher.new.message("USER INFO #{user_info}")
      if user_info.success?
        @unionid = user_info.data[:user_info]['unionid']
      end
    end
  end

  def refresh_openid!
    customer.update(wechat_openid: openid)
  end

  def customer
    @customer ||= existing_customer || new_customer
  end

  def existing_customer
    @existing_customer ||= existing_by_unionid
  end

  def existing_by_unionid
    SlackDispatcher.new.message("UNIONID USED : #{unionid}")
    if unionid
      User.where(provider: provider, wechat_unionid: unionid).first
    end
  end

  def fresh_email
    "#{openid}#{unionid}@wechat.com"
  end

  def new_customer
    User.create({
      :provider              => provider,
      :nickname              => nickname,
      :remote_pic_url        => avatar,
      :email                 => fresh_email,
      :role                  => :customer,
      :gender                => gender,
      :password              => random_password,
      :password_confirmation => random_password,
      :wechat_unionid        => unionid
    })
  end

  def gender
     if sex == 1
       'm'
     else
       'f'
     end
  end

  def random_password
    @random_password ||= SecureRandom.uuid
  end

end
