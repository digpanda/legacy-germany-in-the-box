json.success true
json.skus @skus do |sku|
  json.id sku.id
  json.option_names sku.display_option_names
end
