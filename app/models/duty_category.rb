class DutyCategory
  include MongoidBase
  include CategoryBase

  field :code,            type: String
  field :products_count,  type: Fixnum, default: 0

  has_many :products,  :inverse_of => :duty_category

  validates :code,  presence: true, :unless => lambda { self.parent.blank? }, length: {maximum: Rails.configuration.max_tiny_text_length}

end