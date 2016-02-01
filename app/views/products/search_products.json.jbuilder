json.array!(@products) do |p|
  json.extract! p, :id, :shopname, :name, :brand, :category, :img
  json.shopname p.shop.present? ? p.shop.name : nil
end
