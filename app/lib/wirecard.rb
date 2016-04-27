class Wirecard

  attr_reader :merchant_id, :secret_key, :username, :password

  # https://hostname/engine/rest/merchants/{merchant-account-id}/payments/{transaction-id}
  # https://sandbox-engine.thesolution.com/engine/rest/merchants/dfc3a296-3faf-4a1d-a075-f72f1b67dd2a/payments/af3864e1-0b2b-11e6-9e82-00163e64ea9f

  def initialize(args={})
    @merchant_id ||= args[:merchant_id]
    @secret_key ||= args[:secret_key]
    @username ||= args[:username]
    @password ||= args[:password]
  end

end