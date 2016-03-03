json.extract! product, :id, :name, :brand, :desc
json.cover_url product.cover.url

json.shop do
  json.name product.shop.name
  json.url  shop_url(product.shop)
end

json.categories product.categories.map { |c| { name: c.name, url: category_url(c) } } if product.categories.present?

json.skus product.skus.map { |s| s.get_options_json }