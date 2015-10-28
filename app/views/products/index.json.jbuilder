json.array!(@products) do |product|
  json.extract! product, :id, :desc, :network, :shopname, :prodid, :deeplink, :name, :brand, :category, :img, :imglg, :price, :priceold, :sale, :currency, :update_, :status
  json.url product_url(product, format: :json)
end
