#json.partial! 'products/show', product: @product

json.skus @product.skus do |sku|
  json.id sku.id
  json.discount sku.discount
  json.price sku.price
  json.raw_images_urls sku.raw_images_urls
  json.options sku.options

  #json.url  shop_url(product.shop)
end

=begin
json.id product.id
json.name product.name
json.desc product.desc

json.price product.skus.first.price
json.skus_raw_images_urls product.skus_raw_images_urls
json.sku_count product.skus.count

json.shop_id product.shop.id
json.shop_name product.shop.shopname
json.shop_logo_url product.shop.logo.url

json.brand_name product.brand
=end