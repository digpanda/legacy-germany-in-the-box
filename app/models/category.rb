class Category
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  include DocLocaleName

  strip_attributes

  field :name,  type: String
  field :code,  type: String
  field :cssc,  type: String

  field :name_locales, type: Hash

  has_many :children, :class_name => 'Category', :inverse_of => :parent,  dependent: :restrict
  belongs_to :parent, :class_name => 'Category', :inverse_of => :children

  has_and_belongs_to_many :products,  :inverse_of => :categories

  validates :name,    presence: true
  validates :code,    presence: true, :unless => lambda { self.parent.blank? }

  scope :roots,   ->  { where(:parent => nil) }
end