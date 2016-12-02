class OrderItem
  include MongoidBase

  field :sku_id,      type: String # TODO : remove this one

  field :quantity,        type: Integer,    default: 1
  field :weight,          type: Float,      default: 0
  field :price,           type: BigDecimal, default: 0
  field :product_name,    type: String
  field :option_names,    type: Array

  field :option_ids,  type: Array,      default: []

  embeds_one :sku

  belongs_to :product
  belongs_to :order, touch: true,  :counter_cache => true

  validates :quantity,      presence: true, :numericality => { :greater_than_or_equal_to => 1 }
  validates :weight,        presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :price,         presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :product,       presence: true
  validates :order,         presence: true
  validates :option_ids,    presence: true
  validates :product_name,  presence: true
  validates :option_names,  presence: true

  index({order: 1},  {unique: false, name: :idx_order_item_order})

  def selected_options(locale=nil)
    product.options.map do |option|
      option.suboptions.map do |suboption|
        if option_ids.include? suboption.id.to_s
          if locale.nil?
          suboption.name
          else
          suboption.name_translations[locale]
          end
        end
      end
    end.flatten.compact
  end

  # this method should be used in only a few cases
  # we originally created it to call the BorderGuru API with the correct prices
  # considering the coupon system.
  # using it as end_price would make a double discount which would be false. please avoid this.
  # NOTE : we want to get the `price` per unit not the `total_price` because of BorderGuru API
  def price_with_coupon_applied
    (price * order.total_discount_percent).round(2)
  end

  def total_price
    quantity * price
  end

  def volume
    sku.volume * quantity  # can be many items
  end

  def price_in_yuan
    price ? price * Settings.instance.exchange_rate_to_yuan : 0
  end
end
