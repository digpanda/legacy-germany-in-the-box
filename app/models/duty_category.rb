class DutyCategory
  include MongoidBase
  include CategoryBase

  # add `to_slug` functionality to strings
  String.include CoreExtensions::String::SlugConverter

  SLUG_LANGUAGE = 'en'

  field :code,            type: String
  field :slug,            type: String
  field :tax_rate,        type: Float, default: 0.0
  field :products_count,  type: Fixnum, default: 0

  has_many :products,  inverse_of: :duty_category
  validates :code,  presence: true, unless: lambda { self.parent.blank? }, length: { maximum: Rails.configuration.gitb[:max_tiny_text_length] }

  before_save :add_slug

  def add_slug
    self.slug = name_translations[SLUG_LANGUAGE].to_slug
  end
end
