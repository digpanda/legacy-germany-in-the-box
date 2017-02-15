class ReferrerToken
  include MongoidBase

  field :token, type: String
  field :used_at, type: Time

  before_save :generate_token

  def generate_token
    self.token = SecureRandom.hex(8).upcase
  end

end
