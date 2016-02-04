json.array!(@products) do |p|
  json.extract! p, :id, :name, :brand, :img
  json.shopname p.shop.name if p.shop
  json.categories p.categories.map { |c| c.name } if p.categories.size > 0
end
