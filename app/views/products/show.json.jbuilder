json.extract! @product, :id, :network, :prodid, :deeplink, :name, :brand, :img, :imglg, :price, :priceold, :sale, :currency, :update_, :status, :desc
json.shopname @product.shop.present? ? @product.shop.name : nil
json.category @product.categories.map { |c| c.name }
