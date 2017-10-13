class Metrics < BaseService
  class TotalReferrers < Base

    def settings
      {
        title: '# of Referrer',
        type: :bar,
        vertical_label: 'Demography'
      }
    end

    def render
      draw(:new_referrers_per_month, label: 'New referrers', color: :light)
      draw(:total_referrers_per_month, label: 'Total referrers', color: :blue, type: :line)

      chart.render
    end

    private

      def new_referrers_per_month
        @new_referrers_per_month ||= begin
          Referrer.all.order(c_at: :asc).group_by do |referrer|
            referrer.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            acc.merge({"#{group.first}": group.last.count})
          end
        end
      end

      def total_referrers_per_month
        @total_referrers_per_month ||= begin
          counter = 0
          Referrer.all.order(c_at: :asc).group_by do |referrer|
            referrer.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end
  end
end
