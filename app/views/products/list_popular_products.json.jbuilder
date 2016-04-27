json.products @products do |product|

  json._id product._id
  json.name product.name
  json.brand product.brand
  json.shop_name product.shop.shopname
  json.shop_logo product.shop.logo
  json.sku_image product.get_sku_image # this image was sorted via the skus

end

#json.categories product.categories.map { |c| { name: c.name, url: category_url(c) } } if #product.categories.present?

#json.skus product.skus.map { |s| get_options_json(s) }