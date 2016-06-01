json.extract! sku, :id, :price, :limited, :weight, :status, :customizable, :discount, :quantity
json.currency sku.product.shop.currency.code

json.img0_url sku.img0.url
json.img1_url sku.img1.url
json.img2_url sku.img2.url
json.img3_url sku.img3.url
