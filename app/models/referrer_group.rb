class ReferrerGroup
  include MongoidBase
  include Rails.application.routes.url_helpers

  field :token, type: String
  field :name, type: String
  field :desc, type: String
  field :type, type: Symbol, default: :publisher

  field :coupon_discount, type: Boolean, default: true
  field :coupon_discount_extra, type: Float, default: 0
  field :sales_provision, type: Boolean, default: true
  field :sales_provision_extra, type: Float, default: 0
  field :redeem_discount, type: Float, default: 0

  has_many :referrers, class_name: 'Referrer', inverse_of: :referrer_group

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create :generate_token

  def generate_token
    self.token = SecureRandom.hex(8).upcase
    self.save
  end

  def self.valid_token?(token)
    if ReferrerGroup.where(token: token).first
      true
    else
      false
    end
  end

  def referrer_url
    @referrer_url ||= begin
      url = connect_referrer_registration_path(token: self.token)
      WechatUrlAdjuster.new(url).adjusted_url
    end
    # 'https://open.weixin.qq.com/connect/oauth2/authorize?' +
    #     "appid=#{Rails.application.config.wechat[:username_mobile]}&" +
    #     'redirect_uri=http%3A%2F%2Fgermanyinbox.com/connect/auth/referrer?' +
    #     "token=#{self.token}" +
    #     '&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect'
  end
end
