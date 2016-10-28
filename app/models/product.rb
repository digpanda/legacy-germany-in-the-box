class Product
  include MongoidBase

  MAX_SHORT_TEXT_LENGTH = (Rails.configuration.max_short_text_length * 1.25).round
  MAX_LONG_TEXT_LENGTH = (Rails.configuration.max_long_text_length * 1.25).round

  strip_attributes

  field :name, type: String, localize: true
  field :brand, type: String, localize: true
  field :cover, type: String # deprecated ?
  field :desc, type: String, localize: true
  field :tags, type: Array, default: Array.new(Rails.configuration.max_num_tags)
  field :status, type: Boolean, default: true
  field :approved, type: Time
  field :hs_code, type: String

  embeds_many :options, inverse_of: :product, cascade_callbacks: true, class_name: 'VariantOption'
  embeds_many :skus, inverse_of: :product, cascade_callbacks: true

  has_and_belongs_to_many :collections, inverse_of: :products
  has_and_belongs_to_many :categories, inverse_of: :products

  has_many :order_items, inverse_of: :product

  belongs_to :shop, inverse_of: :products
  belongs_to :duty_category, inverse_of: :products, counter_cache: true

  has_and_belongs_to_many :users, inverse_of: :favorites

  accepts_nested_attributes_for :skus
  accepts_nested_attributes_for :options

  mount_uploader :cover, ProductImageUploader # deprecated ?

  validates :name, presence: true, length:   {maximum: MAX_SHORT_TEXT_LENGTH }
  validates :brand , presence: true, length: {maximum: MAX_SHORT_TEXT_LENGTH }
  validates :shop, presence: true
  validates :status, presence: true
  validates :hs_code, presence: true
  validates :desc, length:                   { maximum: MAX_LONG_TEXT_LENGTH }
  #validates :tags, length:                   { maximum: Rails.configuration.max_num_tags                        }

  scope :is_active,       ->         { self.and(:status  => true, :approved.ne => nil)   }
  scope :has_sku,         ->         { where("skus.0"    => {"$exists" => true})         }
  scope :has_hs_code,     ->         { where(:hs_code.ne => nil)                         }
  scope :has_tag,         -> (value) { where(:tags       => value)                       }
  scope :can_show,        ->         { self.is_active.has_sku                             }
  scope :by_brand,        ->         { self.order(:brand => :asc)                                }
  scope :can_buy,         ->         { self.is_active.has_hs_code.has_sku.can_buy_from_shop }
  scope :can_buy_from_shop, ->       { self.in(shop: Shop.only(:id).can_buy.map(&:id))   }

  index( {name: 1          }, {unique: false, name: :idx_product_name                        })
  index( {brand: 1         }, {unique: false, name: :idx_product_brand                       })
  index( {shop: 1          }, {unique: false, name: :idx_product_shop                        })
  index( {tags: 1          }, {unique: false, name: :idx_product_tags, sparse: true          })
  index( {users: 1         }, {unique: false, name: :idx_product_users, sparse: true         })
  index( {collections: 1   }, {unique: false, name: :idx_product_collections, sparse: true   })
  index( {categories: 1    }, {unique: false, name: :idx_product_categories, sparse: true    })
  index( {duty_category: 1 }, {unique: false, name: :idx_product_duty_category, sparse: true })

  class << self

    def search(query)
      Product.can_buy.where(name: /(#{query.split.join('|')})/i)
    end

    def discount_products
      self.all.to_a.each do |product|
        if product.discount?
          return true
        end
      end
      false
    end

    # fetch the product and place them sorted by category
    # one product can have multiple categories
    def categories_array
      products_hash ||= {}
      self.all.each do |product|
        product.categories.each do |category|
          products_hash["#{category.id}"] ||= []
          products_hash["#{category.id}"] << product
        end
      end
      products_hash
    end

  end

  def favorite_of?(user)
    return unless user
    user.favorites.where(id: self.id).first != nil
  end

  def can_buy?
    active? && hs_code != nil && skus.count > 0 && shop.decorate.can_buy?
  end

  def active?
    status == true && approved != nil
  end

  def has_option?
    options&.select { |o| o.suboptions&.size > 0 }.size > 0
  end

  def grouped_variants_options
    options.map { |v| [v.name, v.suboptions.sort { |a,b| a.name <=> b.name }.map { |o| [ o.name, o.id.to_s]}] }.to_a
  end

  def featured_sku
    @featured_sku ||= available_skus.first
  end

  def best_discount_sku
    @best_discount_sku ||= skus.where(:discount.gt => 0).order_by({:discount => :desc}).first
  end

  def discount?
    skus.where(:discount.gt => 0).count > 0
  end

  def available_skus
    skus.is_active.any_of({:unlimited => true}, {:quantity.gt => 0}).order_by({:discount => :desc}, {:quantity => :desc})
  end

  def sku_from_option_ids(option_ids)
    skus.detect {|s| s.option_ids.to_set == option_ids.to_set}
  end

end
