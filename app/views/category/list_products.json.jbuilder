json.array!(@products) do |p|
  json.extract! p, :id, :name, :brand, :img, :price
  json.set! :shop_id, p.shop.id
  json.set! :shop_name, p.shop.name
end