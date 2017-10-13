class Metrics < BaseService
  class TotalUsers
    TITLE = '# of Users'.freeze
    VERTICAL_LABEL = 'Demography'.freeze

    def initialize
    end

    def render
      draw(:new_users_per_month, label: 'New users', color: :light)
      draw(:total_users_per_month, label: 'Total users', color: :blue, type: :line)

      chart.render
    end

    private

      def draw(metric, *args)
        draw = chart.draw(*args)
        self.send(metric).each do |metric|
          draw.data(position: metric.first, value: metric.last)
        end
        draw.store
      end

      def chart
        @chart ||= Chart.new(title: TITLE, type: :bar, vertical_label: VERTICAL_LABEL)
      end

      # NOTE : metrics must have a format such as {'Entry 1' => 1, 'Entry 2' => 2}
      # this norm will be automatically understood and drawn by the system.
  
      def new_users_per_month
        @new_users_per_month ||= begin
          User.all.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            acc.merge({"#{group.first}": group.last.count})
          end
        end
      end

      def total_users_per_month
        @total_users_per_month ||= begin
          counter = 0
          User.all.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end

  end

end
