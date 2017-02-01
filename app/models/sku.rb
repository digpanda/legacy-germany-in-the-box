class Sku
  include MongoidBase

  Numeric.include CoreExtensions::Numeric::CurrencyLibrary
  FEES_ESTIMATION_EXPIRATION = 1.week.ago

  strip_attributes

  field :img0,          type: String
  field :img1,          type: String
  field :img2,          type: String
  field :img3,          type: String
  field :price,         type: BigDecimal
  field :quantity,      type: Integer
  field :unlimited,     type: Boolean,    default: false
  field :weight,        type: Float
  field :status,        type: Boolean,    default: true
  field :discount,      type: Integer,    default: 0
  field :space_length,  type: Float
  field :space_width,   type: Float
  field :space_height,  type: Float
  field :data,          type: String,     localize: true
  field :attach0,       type: String
  field :country_of_origin, type: String, default: 'DE'

  # TODO : will be removed soon
  # field :fees_estimation, type: Float, default: 0.0
  # field :fees_estimated_at, type: Date

  field :option_ids,    type: Array,      default: []

  embedded_in :product
  embedded_in :order_item

  # sku can be embedded in order_item and product
  # therefore you access the product linked to it
  # in different ways
  def product
    case self._parent.class
    when Product
      self._parent
    when OrderItem
      self._parent.product
    end
  end

  # TODO : this might be in a issue when using the sku from the order item
  # make sure to put the clonage of the images / documentation in the model
  # so it also duplicated when creating from order_item
  mount_uploader :img0,     ProductUploader
  mount_uploader :img1,     ProductUploader
  mount_uploader :img2,     ProductUploader
  mount_uploader :img3,     ProductUploader
  mount_uploader :attach0,  AttachmentUploader

  field :img0_tmp,          type: String
  field :img1_tmp,          type: String
  field :img2_tmp,          type: String
  field :img3_tmp,          type: String
  field :attach0_tmp,       type: String
  
  store_in_background :img0
  store_in_background :img1
  store_in_background :img2
  store_in_background :img3
  store_in_background :attach0

  validates :price,         presence: true, :numericality => { :greater_than => 0 }
  validates :quantity,      presence: true, :numericality => { :greater_than_or_equal_to => 0 }, :unless => lambda { self.unlimited }
  validates :unlimited,     presence: true
  validates :weight,        presence: true
  validates :status,        presence: true
  validates :discount,      presence: true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :option_ids,    presence: true
  validates :space_length,  presence: true, :numericality => { :greater_than => 0 }
  validates :space_width,   presence: true, :numericality => { :greater_than => 0 }
  validates :space_height,  presence: true, :numericality => { :greater_than => 0 }

  # currently not working properly, please do not use this scope
  # NOTE : http://stackoverflow.com/questions/40464883/mongoid-chaining-and-scopes
  scope :can_buy,   -> { is_active.in_stock }
  scope :is_active, -> { where(:status => true) }
  scope :in_stock,  -> { any_of({:unlimited => true  }, {:quantity.gt => 0}) }


  before_save :ensure_valid_option_ids
  before_save :clean_quantity, :if => lambda { self.unlimited }

  def enough_stock?(quantity)
    unlimited || (self.quantity >= quantity)
  end

  def volume
    space_length * space_width * space_height
  end

  def price_with_taxes
    price + estimated_taxes
  end

  def estimated_taxes
    @estimated_taxes ||= begin
      if product.duty_category
        price * (product.duty_category.tax_rate / 100)
      else
        0
      end
    end
  end

  def get_options
    variants = option_ids.map do |option_id|
      product.options.detect do |variant|
        variant.suboptions.where(id: option_id).first
      end
    end

    variants.each_with_index.map do |variant, index|
      option = variant.suboptions.find(self.option_ids[index])
      { name: variant.name, option: { name: option.name } }
    end
  end

  def option_names
    product.options.map do |option|
      option.suboptions.inject([]) do |acc, suboption|
        if option_ids.include? "#{suboption.id}"
          acc << suboption.name
        else
          # not sure about the logic
          # it seems very weird to me
          # but otherwise it blows up
          acc
        end
      end
    end.flatten
  end

  def max_added_to_cart
    [Rails.configuration.achat[:max_add_to_cart_each_time], (self.unlimited ? Rails.configuration.achat[:max_add_to_cart_each_time] : self.quantity)].min
  end

  def all_nonempty_img_fields
    @img_fields ||= self.attributes.keys.grep(/^img\d/).map(&:to_sym).select { |f| f if self.read_attribute(f) }
  end

  def discount?
    discount > 0
  end

  def quantity_warning?
    return false if self.unlimited || nothing_left? # no warning if unlimited or nothing left
    self.quantity <= ::Rails.application.config.digpanda[:products_warning]
  end

  def nothing_left?
    self.quantity == 0 && !self.unlimited
  end

  def more_description?
    self.attach0.file || self.data?
  end

  def data?
    !self.data.nil? || (self.data.is_a?(String) && !self.data.trim.empty?)
  end

  def stock_available_in_order?(quantity_to_add, user_order)
    quantity = user_order&.order_items.with_sku(self)&.first&.quantity
    quantity ||= 0

    !self.unlimited && (self.quantity >= quantity + quantity_to_add)
  end

  private

  def clean_quantity
    self.quantity = 0
  end

  def ensure_valid_option_ids
    self.option_ids = self.option_ids.reject { |c| c.empty? }.to_set.to_a
  end

end
