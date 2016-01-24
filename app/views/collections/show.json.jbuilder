json.collection {
  json.id @collection.id
  json.name @collection.name
  json.desc @collection.desc
  json.visible @collection.public ? '1' : '0'
  json.coltype @collection.coltype
  json.products_imgs @collection.products.map { |p| p.img ? p.img : p.imglg }
  json.owner @collection.user.id.to_s
  json.owner_name @collection.user.username
  json.owner_img request.base_url + @collection.user.pic.url
  json.url collection_url(@collection, format: :json)
}

json.products @products
