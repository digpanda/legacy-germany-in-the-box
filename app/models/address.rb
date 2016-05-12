class Address
  include MongoidBase

  strip_attributes

  field :additional,    type: String
  field :number,        type: String
  field :street,        type: String
  field :district,      type: String
  field :city,          type: String
  field :province,      type: String
  field :zip,           type: String
  field :country,       type: ISO3166::Country
  field :type,          type: String # billing, sender, both

  field :fname,         type: String
  field :lname,         type: String
  field :email,         type: String
  field :mobile,        type: String
  field :tel,           type: String

  field :primary,       type: Boolean,    default: false

  belongs_to :user,     :inverse_of => :addresses;
  belongs_to :shop,     :inverse_of => :address;

  scope :is_billing,  ->  { any_of({type: 'billing'}, {type: 'both'}) }
  scope :is_sender,   ->  { any_of({type: 'sender'}, {type: 'both'}) }

  validates :number,    presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :street,    presence: true,   length: {maximum: Rails.configuration.max_short_text_length}
  validates :city,      presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :zip,       presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :country,   presence: true
  validates :primary,   presence: true

  validates :district,  length: {maximum: Rails.configuration.max_tiny_text_length}, :if => lambda{ self.country_code == 'DE' }
  validates :province,  length: {maximum: Rails.configuration.max_tiny_text_length}, :if => lambda{ self.country_code == 'DE' }

  validates :type,      presence: true,   inclusion: {in: ['billing', 'sender', 'both']},    :if => lambda{ self.country_code == 'DE' }

  validates :district,  presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length},  :if => lambda{ self.country_code == 'zh-CN' }
  validates :province,  presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length},  :if => lambda{ self.country_code == 'zh-CN' }

  def country_code
    country.alpha2
  end

  def country_name
    country.name
  end

  def country_local_name
    country.local_name
  end

end