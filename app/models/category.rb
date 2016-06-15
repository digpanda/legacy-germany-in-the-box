class Category
  include MongoidBase
  include CategoryBase

  has_and_belongs_to_many :products,  :inverse_of => :categories
  
  field :slug, type: String
  field :desc, type: String, localize: true

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

  def shops
    all_shops = Shop.all.map { |s| [s.id, s] }.to_h
    Product.only(:shop_id).where(:category_ids => self.id ).to_a.map { |p| all_shops[p.shop_id] }
  end

  def buyable_shops
    all_shops = Shop.buyable.map { |s| [s.id, s] }.to_h
    Product.only(:shop_id).where(:category_ids => self.id ).to_a.map { |p| all_shops[p.shop_id] }
  end

end