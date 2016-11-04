module BorderGuru
  module Payloads
    module HavingVendibles
      extend ActiveSupport::Concern

      WEIGHT_UNIT = 'kg'

      # HasProductSummaries
      # concern which provides #total_value and #total_weight.
      def product_summaries(order)
        {
          subtotal: order.total_price_with_discount.round(2), #order.total_value,
          totalWeight: order.total_weight,
          dimensionalWeight: order.total_dimensional_weight,
          dimensionalWeightScale: WEIGHT_UNIT,
          totalWeightScale: WEIGHT_UNIT,
        }
      end

      # we will transmit those informations for each single order item to borderguru
      # this line is currently used in the system - Laurent 2016/07/15
      def line_items(order_items)
        order_items.map do |order_item|
          {
            sku: order_item.sku.id,
            shortDescription: order_item.sku.product.name,
            price: order_item.price_with_coupon_applied.to_f.round(2),
            category: Rails.env.production? ? order_item.sku.product.duty_category.code : 'test',
            weight: order_item.weight,
            weightScale: WEIGHT_UNIT,
            countryOfManufacture: order_item.sku.product.shop.sender_address.country.alpha2
          }.merge yield order_item
        end
      end
    end
  end
end
