class Category
  include MongoidBase
  include CategoryBase

  has_and_belongs_to_many :products,  :inverse_of => :categories
  
  field :slug, type: String

  def self.only_with_products
    self.where(:product_ids.ne => nil).and(:product_ids.ne => [])
  end

  def total_products
    if children_count > 0
      children.is_active.inject(0) { |sum, c| sum += c.total_products }
    else
      product_ids ? product_ids.size : 0
    end
  end
end