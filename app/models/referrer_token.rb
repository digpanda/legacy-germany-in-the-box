class ReferrerToken
  include MongoidBase

  field :token, type: String
  field :name, type: String
  field :desc, type: String
  field :type, type: Symbol, default: :publisher
  field :group, type: String
  field :coupon_discount, type: Boolean, default: true
  field :coupon_discount_extra, type: Float, default: 0
  field :sales_provision, type: Boolean, default: true
  field :sales_provision_extra, type: Float, default: 0
  field :redeem_discount, type: Float, default: 0
  field :note, type: String
  field :used_at, type: Time

  validates_presence_of :name, :group
  validates_uniqueness_of :name, :group

  before_save :generate_token

  def generate_token
    self.token = SecureRandom.hex(8).upcase
  end

  def self.valid_token?(token)
    return true if Setting.instance.force_referrer_tokens
    token = ReferrerToken.where(token: token, used_at: nil).first

    if token
      token.update(used_at: Time.now)
      return true
    else
      return false
    end
  end

  def referrer_url
    "https://open.weixin.qq.com/connect/oauth2/authorize?" +
        "appid=#{Rails.application.config.wechat[:username_mobile]}&" +
        "redirect_uri=http%3A%2F%2Fgermanyinbox.com/connect/auth/referrer?" +
        "token%3D#{self.token}" +
        "&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect"
  end
end
