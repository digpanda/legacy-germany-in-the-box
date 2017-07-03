class PaymentGateway
  include MongoidBase

  strip_attributes

  field :provider, type: Symbol
  field :payment_method, type: Symbol

  belongs_to :shop, inverse_of: :payment_gateways

  validates :provider, inclusion: {:in => [:alipay, :wechatpay]}
  validates :payment_method, inclusion: {:in => [:alipay, :wechatpay]}

end
