class Metrics < BaseService
  class TotalUsers < Metrics
    attr_reader :title, :type, :vertical_label

    def initialize
      @title = '# of Users'
      @type = :bar
      @vertical_label = 'Demography'
    end

    def render
      draw(:new_users_per_month, label: 'New users', color: :light)
      draw(:total_users_per_month, label: 'Total users', color: :blue, type: :line)

      chart.render
    end

    private

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
