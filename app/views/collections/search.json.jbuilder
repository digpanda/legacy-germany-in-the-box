json.array!(@collections) do |c|
  json.id c.id
  json.name c.name
  json.desc c.desc
  json.products_imgs c.products.map { |p| p.img0.url ? request.base_url + p.img0.url : nil }
end
