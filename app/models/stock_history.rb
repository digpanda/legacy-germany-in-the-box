class StockHistory
  include MongoidBase

  strip_attributes
  belongs_to :order_item
end
