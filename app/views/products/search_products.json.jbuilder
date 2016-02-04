json.array!(@products) do |p|
  json.extract! p, :id, :name, :brand, :img
  json.shopname p.shop.present? ? p.shop.name : nil
  json.category p.categories.map { |c| c.name }
end
