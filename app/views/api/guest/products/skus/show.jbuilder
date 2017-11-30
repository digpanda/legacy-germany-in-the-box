# Serialize sku for API (we should rethink everything.)
json.extract! @sku, :id, :weight, :status, :discount

json.quantity @sku.max_added_to_cart

json.price_with_currency_yuan @sku.price_with_taxes.in_euro.to_yuan(exchange_rate: @order.exchange_rate).display_html
json.price_with_currency_euro @sku.price_with_taxes.in_euro.display_html

json.price_with_currency_yuan @sku.decorate.after_discount_price.in_euro.to_yuan.display_html
json.price_with_currency_euro @sku.decorate.after_discount_price.in_euro.display_html

json.price_before_discount_in_yuan @sku.product.decorate.preview_price_yuan_html
json.discount @sku.discount

json.images do

  @sku.images.each do |image|
    json.array! [
                  thumb: image.file.url,
                  fullsize: image.file.url,
                  zoomin: image.file.url
                 ]
  end

end

if @sku.attach0
  json.file_attachment @sku.attach0.url
end

if @sku.data?
  json.data @sku.data
  json.data_format @sku.decorate.format_data
end
