json.success true
json.skus @skus do |sku|
  json.id sku.id
  json.option_names sku.option_names.join(', ')
end
