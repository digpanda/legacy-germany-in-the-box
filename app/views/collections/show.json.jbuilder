json.collection {
  json.id @collection.id
  json.name @collection.name
  json.desc @collection.desc
  json.visible @collection.public

  json.products_imgs c.products.map { |p| p.img ? p.img : p.imglg }.compact

  json.set! :owner_id, c.user.id
  json.set! :owner_name, c.user.username
  json.set! :owner_img, c.user.pic.url
}
