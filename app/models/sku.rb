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
  mount_uploader :img0,     ProductImageUploader
  mount_uploader :img1,     ProductImageUploader
  mount_uploader :img2,     ProductImageUploader
  mount_uploader :img3,     ProductImageUploader
  mount_uploader :attach0,  AttachmentUploader

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
    unlimited || (quantity >= quantity)
  end

  def volume
    space_length * space_width * space_height
  end

  def price_with_fees
    price + estimated_fees
  end

  def estimated_fees
    @estimated_fees ||= begin
      if product.duty_category
        price * (product.duty_category.tax_rate / 100)
      else
        0
      end
    end
  end

  # TODO : remove SkuFeesEstimation

  # def update_estimated_fees!
  #   sku_fees_estimation = SkuFeesEstimation.new(self).provide
  #   if sku_fees_estimation.success?
  #     self.fees_estimation = sku_fees_estimation.data[:taxAndDutyCost]
  #     self.fees_estimated_at = Time.now
  #     self.save
  #   end
  # end

  # estimated_fees ||= begin
  #   if self.fees_estimated_at.nil? || (self.fees_estimated_at < FEES_ESTIMATION_EXPIRATION)
  #     update_estimated_fees!
  #   end
  #   self.fees_estimation
  # end

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

  private

  def clean_quantity
    self.quantity = 0
  end

  def ensure_valid_option_ids
    self.option_ids = self.option_ids.reject { |c| c.empty? }.to_set.to_a
  end

end
