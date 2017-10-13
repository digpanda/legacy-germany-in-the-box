class Metrics < BaseService
  class TotalOrders < Metrics

    def initialize
    end

    def settings
      {
        title: '# of Orders',
        type: :bar,
        vertical_label: 'Volume'
      }
    end

    def render
      draw(:new_orders_per_month, label: 'New orders', color: :light)
      draw(:total_orders_per_month, label: 'Total orders', color: :blue, type: :line)
      draw(:total_paid_orders_per_month, label: 'Paid orders', color: :red, type: :line, fill: false)

      chart.render
    end

    private

      # NOTE : metrics must have a format such as {'Entry 1' => 1, 'Entry 2' => 2}
      # this norm will be automatically understood and drawn by the system.
      # all the database request are made here

      def new_orders_per_month
        @new_orders_per_month ||= begin
          Order.all.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            acc.merge({"#{group.first}": group.last.count})
          end
        end
      end

      def total_orders_per_month
        @total_orders_per_month ||= begin
          counter = 0
          Order.all.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end

      def total_paid_orders_per_month
        @total_paid_orders_per_month ||= begin
          counter = 0
          Order.bought.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end

  end
end
