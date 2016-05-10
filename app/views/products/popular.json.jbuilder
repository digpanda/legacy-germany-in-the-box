json.products @products do |product|

  json.id product._id
  json.name product.name
  json.brand product.brand
  json.shop_name product.shop.shopname
  json.shop_id product.shop.id
  json.shop_logo_url product.shop.logo.url
  json.image_url product.decorate.product_cover_url

end
