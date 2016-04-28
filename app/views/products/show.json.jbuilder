#json.partial! 'products/show', product: @product

product = @product

json.id product.id
json.name product.name
json.desc product.desc

json.price product.skus.first.price
json.skus_raw_images_urls product.skus.map { |sku| sku.raw_images_urls }.flatten
json.sku_count product.skus.count

json.shop_id product.shop.id
json.shop_name product.shop.shopname
json.shop_logo_url product.shop.logo.url

json.brand_name product.brand