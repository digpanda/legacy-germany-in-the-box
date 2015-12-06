
class ShopInfo
  include Mongoid::Document

  field :name, type: String
  field :logo, type: String

  belongs_to :shop
end