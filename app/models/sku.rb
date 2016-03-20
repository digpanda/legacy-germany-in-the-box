class Sku
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :img0,          type: String
  field :img1,          type: String
  field :img2,          type: String
  field :img3,          type: String
  field :price,         type: BigDecimal
  field :currency,      type: String,     default: '€'
  field :quantity,      type: Integer
  field :limited,       type: Boolean,    default: true
  field :weight,        type: Float
  field :status,        type: Boolean,    default: true
  field :customizable,  type: Boolean,    default: false
  field :discount,      type: Integer,    default: 0
  field :unit,          type: String
  field :space_length,  type: Float,      default: 0
  field :space_width,   type: Float,      default: 0
  field :space_height,  type: Float,      default: 0
  field :renew,         type: Boolean
  field :timed,         type: Boolean

  field :option_ids,    type: Array,      default: []

  embedded_in :product, :inverse_of => :skus

  mount_uploader :img0,   AttachmentUploader
  mount_uploader :img1,   AttachmentUploader
  mount_uploader :img2,   AttachmentUploader
  mount_uploader :img3,   AttachmentUploader

  validates :price,         presence: true
  validates :currency,      presence: true, inclusion: {in: ['€']}
  validates :quantity,      presence: true, :numericality => { :greater_than_or_equal_to => 0 }, :if => lambda { self.limited }
  validates :limited,       presence: true
  validates :weight,        presence: true
  validates :status,        presence: true
  validates :customizable,  presence: true
  validates :discount,      presence: true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :option_ids,    presence: true

  validates :unit,          presence: true, inclusion: {in: ['g', 'kg', 'ml', 'l']}

  validates :space_length,  presence: true
  validates :space_width,   presence: true
  validates :space_height,  presence: true

  scope :is_active,       ->        { where( :status => true ) }
  scope :in_stock,        ->        { where( :quantity.gt => 0 ) }

  before_save :clean_blank_and_duplicated_option_ids
  before_save :clean_quantity, :unless => lambda { self.limited }

  private

  def clean_quantity
    self.quantity = nil
  end

  def clean_blank_and_duplicated_option_ids
    self.option_ids = self.option_ids.reject { |c| c.empty? }.to_set.to_a
  end

end
