json.extract! product, :id, :desc, :network, :prodid, :deeplink, :name, :brand, :img, :imglg, :price, :sale, :currency, :status
json.shopname product.shop.name
json.categories product.categories.map { |c| c.name }