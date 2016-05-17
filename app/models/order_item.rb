class OrderItem
  include MongoidBase

  field :quantity,        type: Integer,    default: 1
  field :weight,          type: Float,      default: 0
  field :price,           type: BigDecimal, default: 0
  field :product_name,    type: String
  field :option_names,    type: Array

  field :sku_id,      type: String
  field :option_ids,  type: Array,      default: []

  belongs_to :product,  :inverse_of => :order_items
  belongs_to :order,    :inverse_of => :order_items,  touch: true

  validates :quantity,      presence: true, :numericality => { :greater_than_or_equal_to => 1 }
  validates :weight,        presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :price,         presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :product,       presence: true
  validates :order,         presence: true
  validates :sku_id,        presence: true
  validates :option_ids,    presence: true
  validates :product_name,  presence: true, length: {maximum: Rails.configuration.max_short_text_length}
  validates :option_names,  presence: true

  index({order: 1},  {unique: false,   name: :idx_order_item_order})

  def sku
    @sku ||= product.skus.find(self.sku_id)
  end
end