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
  field :limited,       type: Boolean,    default: false
  field :weight,        type: Float,      default: 0
  field :status,        type: Symbol,     default: :active
  field :customizable,  type: Boolean,    default: false
  field :discount,      type: BigDecimal, default: 0

  mount_uploader :img0,   AttachmentUploader
  mount_uploader :img1,   AttachmentUploader
  mount_uploader :img2,   AttachmentUploader
  mount_uploader :img3,   AttachmentUploader

  field :options,   type: Array,      default: []

  embedded_in :product, :inverse_of => :skus

  validates :price,         presence: true
  validates :currency,      presence: true, inclusion: {in: ['€']}
  validates :quantity,      presence: true, :numericality => { :greater_than_or_equal_to => 0 }, :if => lambda { self.limited }
  validates :limited,       presence: true
  validates :weight,        presence: true
  validates :status,        presence: true, inclusion: {in: [:active, :inactive]}
  validates :customizable,  presence: true
  validates :discount,      presence: true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1 }

end
