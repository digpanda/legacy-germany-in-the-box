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
  field :status,        type: String,     default: 'active'
  field :customizable,  type: Boolean,    default: false
  field :discount,      type: BigDecimal, default: 0

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
  validates :status,        presence: true, inclusion: {in: ['active', 'inactive']}
  validates :customizable,  presence: true
  validates :discount,      presence: true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1 }
  validates :option_ids,    presence: true

  before_save :clean_blank_and_duplicated_option_ids
  before_save :clean_quantity, :unless => lambda { self.limited }

  private

  def clean_quantity
    self.quantity = nil
  end

  def clean_blank_and_duplicated_option_ids
    self.option_ids = self.options_ids.map { |id| id if not id.blank? }.to_set.to_a
  end

end
