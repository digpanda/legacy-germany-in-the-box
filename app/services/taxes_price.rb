# very small library to calculate the taxes
class TaxesPrice < BaseService
  CONSTANT_RATE = 11.9.freeze
  SPECIAL_CONSTANT_RATE = 26.63.freeze

  attr_reader :sku, :product

  def initialize(sku)
    @sku = sku
    @product = sku.product
  end

  def price
    if product.taxes_base == :constant
      from_constant
    elsif product.taxes_base == :special_constant
      from_special_constant
    elsif product.taxes_base == :duty_category
      from_duty_category
    else
      0.0
    end
  end

  def from_special_constant
    (sku.casual_price * (SPECIAL_CONSTANT_RATE / 100)).to_f
  end

  def from_constant
    (sku.casual_price * (CONSTANT_RATE / 100)).to_f
  end

  def from_duty_category
    if product.duty_category
      (sku.purchase_price * (product.duty_category.tax_rate / 100)).to_f
    else
      0.0
    end
  end
end
