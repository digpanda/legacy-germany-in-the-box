class Metrics < BaseService
  class AllShippingRates < Base

    LINES = [:blue, :green, :red, :black, :purple].freeze

    def settings
      {
        title: 'Shipping Rates',
        type: :line,
        vertical_label: 'Price per kilo'
      }
    end

    def render
      ordered_rates.each_with_index do |rate, index|
        label = rate.first
        @current_line_rates = rate.last
        draw(:line_rates, label: label, color: LINES[index], type: :line)
      end
      chart.render
    end

    private

      def ordered_rates
        @ordered_rates ||= begin
          ShippingRate.all.group_by do |shipping_rate|
            shipping_rate.partner
          end
        end
      end

      def line_rates
        @current_line_rates.reduce({}) do |acc, rate|
          acc.merge({"#{rate.weight}": rate.price})
        end
      end

  end
end
