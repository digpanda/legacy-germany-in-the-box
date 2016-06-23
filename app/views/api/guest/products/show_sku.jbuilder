# Serialize sku for API (we should rethink everything.)
json.extract! @sku, :id, :weight, :status, :customizable, :discount, :quantity

json.price_with_currency_yuan @sku.decorate.price_with_currency
json.price_with_currency_euro @sku.decorate.price_with_currency_euro

json.images do

  [*0..3].each do |n|
    label = "img#{n}"
    json.array! [{
      :thumb => @sku.decorate.image_url(label, :thumb),
      :fullsize => @sku.decorate.image_url(label, :fullsize),
      :zoomin => @sku.decorate.image_url(label, :zoomin)
      }]
  end

end
