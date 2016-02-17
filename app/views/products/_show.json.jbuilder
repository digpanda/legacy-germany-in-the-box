json.extract! product, :id, :desc, :network, :prodid, :deeplink, :name, :brand, :img0, :price, :sale, :currency, :status
json.set! product.img0.url ? request.base_url + product.img0.url : product.img
json.shopname product.shop.name if product.shop.present?
json.categories product.categories.map { |c| c.name } if product.categories.present?