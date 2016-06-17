class Sku
  include MongoidBase

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
  field :customizable,  type: Boolean,    default: false
  field :discount,      type: Integer,    default: 0
  field :space_length,  type: Float
  field :space_width,   type: Float
  field :space_height,  type: Float
  field :time,          type: String,     default: 'terminated'
  field :data,          type: String,     localize: true
  field :attach0,       type: String

  field :option_ids,    type: Array,      default: []

  embedded_in :product, :inverse_of => :skus

  mount_uploader :img0,     ProductImageUploader
  mount_uploader :img1,     ProductImageUploader
  mount_uploader :img2,     ProductImageUploader
  mount_uploader :img3,     ProductImageUploader
  mount_uploader :attach0,  AttachmentUploader

  validates :price,         presence: true,   :numericality => { :greater_than => 0 }
  validates :quantity,      presence: true,   :numericality => { :greater_than_or_equal_to => 0 }, :unless => lambda { self.unlimited }
  validates :unlimited,     presence: true
  validates :weight,        presence: true
  validates :status,        presence: true
  validates :customizable,  presence: true
  validates :discount,      presence: true,   :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :option_ids,    presence: true
  validates :time,          presence: true,   inclusion: {in: ['terminated', 'automatic']}
  validates :space_length,  presence: true,   :numericality => { :greater_than => 0 }
  validates :space_width,   presence: true,   :numericality => { :greater_than => 0 }
  validates :space_height,  presence: true,   :numericality => { :greater_than => 0 }

  scope :is_active,       ->        { where( :status => true ) }
  scope :in_stock,        ->        { where( :quantity.gt => 0 ) }
  scope :buyable,         ->        { where( :status => true ).where( :quantity.gt => 0 ) }

  before_save :clean_blank_and_duplicated_option_ids
  before_save :clean_quantity, :if => lambda { self.unlimited }

  def get_options
    variants = self.option_ids.map do |oid|
      self.product.options.detect do |v|
        v.suboptions.find(oid)
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(self.option_ids[i])
      { name: v.name, option: { name: o.name } }
    end
  end


  private

  def clean_quantity
    self.quantity = 0
  end

  def clean_blank_and_duplicated_option_ids
    self.option_ids = self.option_ids.reject { |c| c.empty? }.to_set.to_a
  end

end
