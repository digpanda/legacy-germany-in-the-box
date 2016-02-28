class Product
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :name,        type: String
  field :brand,       type: String
  field :cover,       type: String
  field :desc,        type: String
  field :tags,        type: Array,  default: Array.new(3)

  embeds_many :variants,  inverse_of: :product,   cascade_callbacks: true
  embeds_many :skus,      inverse_of: :product,   cascade_callbacks: true

  has_and_belongs_to_many :collections, inverse_of: :products
  has_and_belongs_to_many :categories,  inverse_of: :products

  has_many :order_items,  inverse_of: :product,   dependent: :restrict

  belongs_to :shop, inverse_of: :products

  accepts_nested_attributes_for :skus
  accepts_nested_attributes_for :variants

  mount_uploader :cover,   AttachmentUploader

  validates :name,        presence: true
  validates :brand ,      presence: true
  validates :shop,        presence: true
  validates :categories,  presence: true

  scope :has_tag,         ->(value) { where(:tags => value) }

  def get_mas
    sku = skus.detect { |s| not s.limited }
    sku = skus.sort { |s1, s2| s1.quantity <=> s2.quantity }.last unless sku

    return sku
  end

  def get_mas_img_url(img_field)
    mas = get_mas

    return nil unless mas

    if img_field == :img0
      mas.img0 ? mas.img0.url : nil
    elsif img_field == :img1
      mas.img1 ? mas.img1.url : nil
    elsif img_field == :img2
      mas.img2 ? mas.img2.url : nil
    elsif img_field == :img3
      mas.img3 ? mas.img3.url : nil
    end
  end

  def get_sku(option_ids)
    skus.detect {|s| s.option_ids.to_set == option_ids.to_set}
  end

  index({name: 1},          {unique: false, name: :idx_product_name})
  index({brand: 1},         {unique: false, name: :idx_product_brand})
  index({shop: 1},          {unique: false, name: :idx_product_shop})
  index({tags: 1},          {unique: false, name: :idx_product_tags,        sparse: true})
  index({users: 1},         {unique: false, name: :idx_product_users,       sparse: true})
  index({collections: 1},   {unique: false, name: :idx_product_collections, sparse: true})
  index({categories: 1},    {unique: false, name: :idx_product_categories,  sparse: true})
end