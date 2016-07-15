module BorderGuru
  module Payloads
    module HavingVendibles
      extend ActiveSupport::Concern

      WEIGHT_UNIT = 'kg'

      # list_holder is usually a cart or an order,
      # both models that implement the HasProductSummaries
      # concern which provides #total_value and #total_weight.
      def product_summaries(list_holder)
        {
          subtotal: list_holder.total_value,
          totalWeight: list_holder.total_weight,
          dimensionalWeight: list_holder.total_dimensional_weight,
          dimensionalWeightScale: WEIGHT_UNIT,
          totalWeightScale: WEIGHT_UNIT,
        }
      end

      # we will transmit those informations for each single order item to borderguru
      # this line is currently used in the system - Laurent 2016/07/15
      def line_items(skus)
        skus.map do |s|
          {
            sku: s.id,
            shortDescription: s.sku.product.name,
            price: s.price,
            category: Rails.env.production? ? s.sku.product.duty_category.code : 'test',
            weight: s.weight,
            weightScale: WEIGHT_UNIT,
            countryOfManufacture: s.sku.product.shop.sender_address.country.alpha2
          }.merge yield s
        end
      end
    end
  end
end
