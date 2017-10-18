class WebhookCache
  include MongoidBase

  strip_attributes
  field :key, type: String, presence: true, uniqueness: true
  field :section, type: Symbol

  scope :cached?, -> (key) { where(key: key).count > 0 }

end
