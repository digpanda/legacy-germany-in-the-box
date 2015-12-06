class ProductInfo
  include Mongoid::Document

  field :name, as: :name, type: String
  field :bran, as: :brand, type: String
  field :thum, as: :thumbnail, type: String
  field :pric, as: :price, type: BigDecimal
  field :curr, as: :currency, type: String

  embeds_one :shop_info
  belongs_to :product

  index({"shop_info._id" => 1}, {sparse: true, unique: false})
end