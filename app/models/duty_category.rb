class DutyCategory
  include MongoidBase
  include CategoryBase

  field :code,  type: String

  validates :code,  presence: true, :unless => lambda { self.parent.blank? }, length: {maximum: Rails.configuration.max_tiny_text_length}
end