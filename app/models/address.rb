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
  field :country,       type: String
  field :type,          type: String

  field :fname,         type: String
  field :lname,         type: String
  field :email,         type: String
  field :mobile,        type: String
  field :tel,           type: String

  field :primary,       type: Boolean,    default: false

  belongs_to :user,     :inverse_of => :addresses;
  belongs_to :shop,     :inverse_of => :address;

  has_and_belongs_to_many :orders,  :inverse_of => :delivery_destination

  validates :number,    presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :street,    presence: true,   length: {maximum: Rails.configuration.max_short_text_length}
  validates :city,      presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :zip,       presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :country,   presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :primary,   presence: true

  validates :district,  length: {maximum: Rails.configuration.max_tiny_text_length}, :if => lambda{ self.country == 'Deutschland' }
  validates :province,  length: {maximum: Rails.configuration.max_tiny_text_length}, :if => lambda{ self.country == 'Deutschland' }

  validates :type,      presence: true,   inclusion: {in: ['billing', 'sender', 'both']},    :if => lambda{ self.country == 'Deutschland' }

  validates :district,  presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length},  :if => lambda{ self.country == '中国' }
  validates :province,  presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length},  :if => lambda{ self.country == '中国' }
end