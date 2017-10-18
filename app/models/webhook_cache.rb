class WebhookCache
  include MongoidBase

  strip_attributes
  field :key, type: String
  field :section, type: Symbol

  validates :key, presence: true, uniqueness: true

  def self.cached?(key)
    self.where(key: key).count > 0
  end

end
