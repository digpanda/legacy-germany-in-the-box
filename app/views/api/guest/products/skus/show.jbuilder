# Serialize sku for API (we should rethink everything.)
json.extract! @sku, :id, :weight, :status, :customizable, :discount

json.quantity @sku.decorate.max_added_to_cart

json.price_with_currency_yuan @sku.decorate.price_with_currency_yuan_html
json.price_with_currency_euro @sku.decorate.price_with_currency_euro_html

json.price_before_discount_in_yuan @sku.decorate.price_before_discount_in_yuan_html
json.price_before_discount_in_euro @sku.decorate.price_before_discount_in_euro_html
json.discount_with_percent @sku.decorate.discount_with_percent
json.discount @sku.discount

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

if @sku.attach0
  json.file_attachment @sku.attach0.url
end

if @sku.data?
  json.data @sku.data
  json.data_format @sku.decorate.format_data
end
