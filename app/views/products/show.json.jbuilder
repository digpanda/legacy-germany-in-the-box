json.extract! @product, :id, :network, :prodid, :deeplink, :name, :brand, :img, :imglg, :price, :priceold, :sale, :currency, :update_, :status, :desc
json.shopname @product.shop.name
json.category @product.categories.map { |c| c.name }
