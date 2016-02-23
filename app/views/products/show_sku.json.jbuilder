json.extract! @sku, :id, :price, :currency, :quantity, :limited, :weight, :status, :customizable, :discount

json.set! :product_id, @sku.product.id.to_s

json.set! :img0, @sku.img0.url
json.set! :img1, @sku.img1.url
json.set! :img2, @sku.img2.url
json.set! :img3, @sku.img3.url

