# Serialize sku for API (we should rethink everything.)
json.extract! @sku, :id, :weight, :status, :customizable, :discount

json.quantity @sku.decorate.max_added_to_cart

json.price_with_currency_yuan @sku.decorate.price_with_currency
json.price_with_currency_euro @sku.decorate.price_with_currency_euro

json.images do

  #todo Hi Laurent, I think you can just change [*0..3].each to (0..3).each. Regards Yu
  [*0..3].each do |n|
    label = "img#{n}"
    json.array! [{
      :thumb => @sku.decorate.image_url(label, :thumb),
      :fullsize => @sku.decorate.image_url(label, :fullsize),
      :zoomin => @sku.decorate.image_url(label, :zoomin)
      }]
  end

end
