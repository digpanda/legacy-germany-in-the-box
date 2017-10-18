class WebhookCache
  include MongoidBase

  strip_attributes
  field :key, type: String
  field :section, type: Symbol

  scope :cached?, -> (key) { false } # { where(key: key).count > 0 }

  validates :key, presence: true, uniqueness: true

end
