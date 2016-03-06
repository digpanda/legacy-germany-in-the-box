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
  field :quantity,      type: Integer,    default: 0
  field :limited,       type: Boolean,    default: true
  field :weight,        type: Float,      default: 0
  field :status,        type: Boolean,    default: true
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
  validates :status,        presence: true
  validates :customizable,  presence: true
  validates :discount,      presence: true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1 }
  validates :option_ids,    presence: true

  scope :is_active,       ->        { where( :status => true ) }

  before_save :clean_blank_and_duplicated_option_ids
  before_save :clean_quantity, :unless => lambda { self.limited }

  def get_options_json
    variants = self.option_ids.map do |oid|
      self.product.options.detect do |v|
        v.suboptions.find(oid)
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(option_ids[i])
      { name: v.name, name_locales: v.name_locales, option: { id: o.id, name: o.name, name_locales: o.name_locales } }
    end
  end

  def get_option(oid)
    options = self.options_ids.map {}
    ids = self.option_ids.map { |oid| self.product.options.map { |v| o = v.suboptions.find(oid); o.id if o }.compact.join }
    names = self.option_ids.map { |oid| self.product.options.map { |v| o = v.suboptions.find(oid); o.name if o }.compact.join }
  end

  private

  def clean_quantity
    self.quantity = nil
  end

  def clean_blank_and_duplicated_option_ids
    self.option_ids = self.option_ids.reject { |c| c.empty? }.to_set.to_a
  end

end
