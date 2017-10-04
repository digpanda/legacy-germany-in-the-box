class Service
  include MongoidBase
  include Mongoid::Search
  include Mongoid::Slug

  MAX_SHORT_TEXT_LENGTH = (Rails.configuration.gitb[:max_short_text_length] * 1.25).round
  MAX_LONG_TEXT_LENGTH = (Rails.configuration.gitb[:max_long_text_length] * 1.25).round

  strip_attributes

  # research system
  search_in :name, :desc, category: :name, brand: :name

  field :name, type: String
  slug :name, history: true

  field :cover, type: String
  field :desc, type: String
  field :long_desc, type: String
  field :active, type: Boolean, default: true
  field :referrer_rate, type: Float, default: 0.0
  field :position, type: Integer, default: 0

  belongs_to :category
  belongs_to :brand, inverse_of: :services

  has_many :inquiries, inverse_of: :services

  mount_uploader :cover, ServiceUploader

  validates :name, presence: true, length: { maximum: MAX_SHORT_TEXT_LENGTH }
  validates :brand, presence: true
  validates :active, presence: true
  validates :desc, length: { maximum: MAX_LONG_TEXT_LENGTH }

  scope :active,   -> { self.and(active: true) }
end
