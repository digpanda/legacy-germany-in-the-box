json.array!(@products) do |p|
  json.extract! p, :id, :name, :brand, :img
  json.shopname Mongoid::QueryCache.cache { Shop.find( p.shop.id ) }.name  if p.shop
  json.categories p.categories.map { |c| Mongoid::QueryCache.cache { Category.find( c.id ) }.name } if p.categories.size > 0
end
