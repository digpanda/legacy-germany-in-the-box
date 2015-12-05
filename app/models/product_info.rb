class Product
  include Mongoid::Document

  field :n, as: :name, type: String

  field :b, as: :brand, type: String

  field :t, as: :thumbnail, type: String

  field :p, as: :price, type: BigDecimal

  field :c, as: :currency, type: String

  field :sn, as: :shop_name, type: String

  field :si, as: :shop_icon, type: String

end