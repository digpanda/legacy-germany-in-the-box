module BorderGuru
  module Payloads
    module HavingVendibles
      extend ActiveSupport::Concern

      WEIGHT_UNIT = 'kg'

      # HasProductSummaries
      # concern which provides #total_value and #total_weight.
      # BIG NOTE : total_price_with_discount_from_product was originally total_price_with_discount
      # IT MUST BE REMOVED AFTER I MERGE THE NEW CHANGES FROM STAGING
      # WE SHOULD BASICALLY REVERSE THE CALCULATIONS TO BE CLEAN.
      # IT WAS MADE BECAUSE OF THE FEW ORDERS THAT GOT STUCK
      def product_summaries(order)
        {
          subtotal: order.total_price_with_discount_from_product,
          totalWeight: order.total_weight,
          dimensionalWeight: order.total_dimensional_weight,
          dimensionalWeightScale: WEIGHT_UNIT,
          totalWeightScale: WEIGHT_UNIT,
        }
      end

      def line_items(order_items)
        order_items.map.each_with_index do |order_item, index|
          {
            sku: order_item.sku.id,
            shortDescription: order_item.product.name,
            # NOTE : the adjusted price was commented temporarily, see above.
            price: order_item.price_with_coupon_applied, #adjusted_order_item_price(order_item, index).to_f,
            category: Rails.env.production? ? order_item.product.duty_category.code : 'test',
            weight: order_item.weight,
            weightScale: WEIGHT_UNIT,
            countryOfManufacture: order_item.product.shop.sender_address.country.alpha2
          }.merge yield(order_item)
        end
      end

      private

      # sum of the rounded order items
      # NOTE : this can be slightly different from the subtotal / totalPrice
      def adjusted_price(order)
        order.order_items.inject(0) do |acc, current_order_item|
          # we need the quantity because the shown price is per unit
          # but the adjusted price need the `total_price`
          acc = acc + (current_order_item.price_with_coupon_applied * current_order_item.quantity)
        end
      end

      # the fact we use discount can make a few cents difference
      # which have to be compensated to the first order item if needed
      # to stay exact through the API
      def subtotal_difference(order)
        (order.total_price_with_discount - adjusted_price(order).round(2))
      end

      # we adjust the item price by adding the difference with the rounded subtotal
      # to the first order item
      # so the system is always very exact.
      # we could have gone the other way around (adjust the total_price) but it wouldn't match
      # with the price the customers pay therefore i made it this way.
      def adjusted_order_item_price(order_item, index)
        if index == 0
          order_item.price_with_coupon_applied - subtotal_difference(order_item.order)
        else
          order_item.price_with_coupon_applied
        end
      end

    end
  end
end
