product = @product

json.favorites @favorites

json.product do

  json.id product.id
  json.name product.name

end

json.success true
