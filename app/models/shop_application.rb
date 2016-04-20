class ShopApplication
  include MongoidBase

  strip_attributes

  field :email,           type: String
  field :name,            type: String
  field :desc,            type: String
  field :philosophy,      type: String
  field :stories,         type: String
  field :founding_year,   type: String
  field :register,        type: String
  field :code,            type: String
  field :website,         type: String
  field :uniqueness,      type: String
  field :german_essence,  type: String
  field :sales_channels,  type: Array,      default: []

  field :fname,           type: String
  field :lname,           type: String
  field :mobile,          type: String
  field :tel,             type: String
  field :mail,            type: String
  field :function,        type: String

  validates :email,         presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :name,          presence: true,   length: {maximum: (Rails.configuration.max_tiny_text_length * 1.25).round}
  validates :founding_year, presence: true,   length: {maximum: 4}
  validates :desc,          presence: true,   length: {maximum: (Rails.configuration.max_medium_text_length * 1.25).round}
  validates :philosophy,    presence: true,   length: {maximum: (Rails.configuration.max_long_text_length * 1.25).round}

  validates :code,            length: {maximum: Rails.configuration.max_short_text_length}
  validates :website,         length: {maximum: (Rails.configuration.max_short_text_length * 1.25).round}
  validates :stories,         length: {maximum: (Rails.configuration.max_long_text_length * 1.25).round}
  validates :register,        length: {maximum: (Rails.configuration.max_tiny_text_length * 1.25).round}
  validates :sales_channels,  length: {minimum: 2, maximum: Rails.configuration.max_num_sales_channels * 2}

  validates :fname,         presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :lname,         presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :tel,           presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :mail,          presence: true,   length: {maximum: Rails.configuration.max_short_text_length}

  validates :mobile,        length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :function,      length: {maximum: Rails.configuration.max_tiny_text_length}


  before_save :gen_code;

  def gen_code
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    self.code = crypt.encrypt_and_sign(self.email)
  end

  index({code: 1},          {unique: false, name: :idx_code})
  index({email: 1},         {unique: false, name: :idx_name})
end