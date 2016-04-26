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
          totalWeightScale: WEIGHT_UNIT,
        }
      end

      def line_items(products)
        products.map do |prod|
          {
            sku: prod.prodid,
            shortDescription: prod.name,
            price: prod.price,
            category: (Rails.env.test? ? 'test' : prod.duty_category.border_guru_id),
            weight: prod.weight_in_kg,
            weightScale: WEIGHT_UNIT,
            countryOfManufacture: prod.country_of_manufacture.alpha2
          }.merge yield prod
        end
      end
    end
  end
end
