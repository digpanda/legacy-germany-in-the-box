class ReferrerToken
  include MongoidBase

  field :token, type: String
  field :used_at, type: Time

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
end
