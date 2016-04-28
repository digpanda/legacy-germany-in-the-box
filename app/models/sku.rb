class Sku
  include MongoidBase

  strip_attributes

  field :img0,          type: String
  field :img1,          type: String
  field :img2,          type: String
  field :img3,          type: String
  field :price,         type: BigDecimal
  field :quantity,      type: Integer
  field :limited,       type: Boolean,    default: true
  field :weight,        type: Float
  field :status,        type: Boolean,    default: true
  field :customizable,  type: Boolean,    default: false
  field :discount,      type: Integer,    default: 0
  field :unit,          type: String
  field :space_length,  type: Float
  field :space_width,   type: Float
  field :space_height,  type: Float
  field :time,          type: String,     default: 'terminated'

  field :option_ids,    type: Array,      default: []

  embedded_in :product, :inverse_of => :skus

  mount_uploader :img0,   ProductImageUploader
  mount_uploader :img1,   ProductImageUploader
  mount_uploader :img2,   ProductImageUploader
  mount_uploader :img3,   ProductImageUploader

  validates :price,         presence: true
  validates :quantity,      presence: true,   :numericality => { :greater_than_or_equal_to => 0 }, :if => lambda { self.limited }
  validates :limited,       presence: true
  validates :weight,        presence: true
  validates :status,        presence: true
  validates :customizable,  presence: true
  validates :discount,      presence: true,   :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :option_ids,    presence: true
  validates :time,          presence: true,   inclusion: {in: ['terminated', 'automatic']}

  validates :unit,          presence: true,   inclusion: {in: ['g', 'kg', 'ml', 'l']}

  validates :space_length,  presence: true,   :numericality => { :greater_than => 0 }
  validates :space_width,   presence: true,   :numericality => { :greater_than => 0 }
  validates :space_height,  presence: true,   :numericality => { :greater_than => 0 }

  scope :is_active,       ->        { where( :status => true ) }
  scope :in_stock,        ->        { where( :quantity.gt => 0 ) }

  before_save :clean_blank_and_duplicated_option_ids
  before_save :clean_quantity, :unless => lambda { self.limited }

  # might need new refacto below
  def filter_start_with(start)
    as_json.select { |k| k.to_s.match(/^#{start}/) }
  end

  def options
    option_ids.map { |id| self.product.options.map { |op| op.suboptions.find(id).name } }.flatten
  end

  def raw_images_urls
    filter_start_with("img").to_a.map.each_with_index { |d| d[1]["url"] }.compact.flatten
  end

  #class << self

  #  def images_urls
  #    all.inject([]) { |array,sku| array << sku.filter_start_with("img") }
  #  end

  #end

  private

  def clean_quantity
    self.quantity = nil
  end

  def clean_blank_and_duplicated_option_ids
    self.option_ids = self.option_ids.reject { |c| c.empty? }.to_set.to_a
  end

end
