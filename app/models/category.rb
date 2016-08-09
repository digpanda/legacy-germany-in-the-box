class Category
  include MongoidBase
  include CategoryBase

  has_and_belongs_to_many :products,  :inverse_of => :categories
  
  field :slug, type: String
  field :desc, type: String, localize: true

  scope :only_with_products,       ->    { where(:product_ids.ne => nil).and(:product_ids.ne => []) }

  def shops
    all_shops = Shop.all.map { |s| [s.id, s] }.to_h
    Product.only(:shop_id).where(:category_ids => self.id ).to_a.map { |p| all_shops[p.shop_id] }
  end

  def can_buy_shops
    all_shops = Shop.can_buy.map { |s| [s.id, s] }.to_h
    Product.only(:shop_id).where(:category_ids => self.id ).to_a.map { |p| all_shops[p.shop_id] }
  end

end