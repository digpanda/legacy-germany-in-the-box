class Metrics < BaseService
  class TotalPayments < Metrics
    class << self

      def settings
        {
          title: '# of Payments',
          type: :bar,
          vertical_label: 'Volume'
        }
      end

      def render
        draw(:new_payments_per_month, label: 'Confirmed payments', color: :light)
        draw(:volume_paid_per_month, label: 'Volume paid', color: :blue)
        chart.render
      end

      private

        def new_payments_per_month
          @new_payments_per_month ||= begin
            OrderPayment.where(status: :success).order(c_at: :asc).group_by do |user|
              user.c_at.strftime('%Y-%m')
            end.reduce({}) do |acc, group|
              acc.merge({"#{group.first}": group.last.count})
            end
          end
        end

        def volume_paid_per_month
          @volume_paid_per_month ||= begin
            OrderPayment.where(status: :success).order(c_at: :asc).group_by do |user|
              user.c_at.strftime('%Y-%m')
            end.reduce({}) do |acc, group|
              amount_eur = group.last.map(&:amount_eur).sum.round(2)
              acc.merge({"#{group.first}": amount_eur})
            end
          end
        end

    end
  end
end
