product = @product

json.favorites @favorites # to go shorter just make a count instead if details not needed for the API

json.product do

  json.id product.id
  json.name product.name

end

json.success = true