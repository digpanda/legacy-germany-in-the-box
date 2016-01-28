class Category
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  field :name,  type: String
  field :desc,  type: String # not needed
  field :code,  type: String
  field :cssc,  type: String

  field :name_locales, type: Hash

  has_many :children, :class_name => 'Category', :inverse_of => :parent
  belongs_to :parent, :class_name => 'Category', :inverse_of => :children

  has_and_belongs_to_many :products

  def get_number_of_different_products
    if parent.present?
      products.count
    else
      children.inject(0) { |sum, child| sum += child.products.count }
    end
  end
end