json.products @products do |product|

  json.id product._id
  json.name product.name
  json.brand product.brand
  json.shop_name product.shop.shopname
  json.shop_id product.shop.id
  json.shop_logo_url product.shop.logo.url
  json.product_image_url product.get_sku_image_url # this image was sorted via the skus

end

#json.categories product.categories.map { |c| { name: c.name, url: category_url(c) } } if #product.categories.present?

#json.skus product.skus.map { |s| get_options_json(s) }