json.products @products do |product|

  binding.pry
  
  json.id product._id
  json.name product.name
  json.brand product.brand
  json.shop_name product.shop.shopname
  json.shop_id product.shop.id
  json.shop_logo_url product.shop.logo.url
  json.product_image_url product.get_sku_image_url

end
