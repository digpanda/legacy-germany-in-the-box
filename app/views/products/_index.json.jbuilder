json.array!(products) do |product|
  json.partial! 'products/show', product: product
end
