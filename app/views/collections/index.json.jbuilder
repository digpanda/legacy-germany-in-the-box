json.array!(@collections) do |c|
  json.id c.id
  json.name c.name
  json.desc c.desc
  json.coltype c.coltype
  json.products_imgs c.products.map { |p| p.img ? p.img : p.imglg }
  json.owner c.user.id.to_s
  json.owner_name c.user.username
  json.owner_img request.base_url + c.user.pic.url
  json.url collection_url(c, format: :json)
end
