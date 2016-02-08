class Brand
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :name, type: String

  validates :name,  presence: true
end
