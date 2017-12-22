class Metrics < BaseService
  class TotalUsers < Base

    def settings
      {
        title: '# of Users',
        type: :bar,
        vertical_label: 'Demography'
      }
    end

    def render
      draw(:new_users_per_month, label: 'New users', color: :light)
      draw(:total_users_per_month, label: 'Total users', color: :blue, type: :line)
      draw(:total_paid_users_per_month, label: 'Total paid users', color: :purple, type: :line)

      chart.render
    end

    private

      # NOTE : metrics must have a format such as {'Entry 1' => 1, 'Entry 2' => 2}
      # this norm will be automatically understood and drawn by the system.
      # all the database request are made here

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

      def total_paid_users_per_month
        @total_paid_users_per_month ||= begin
          counter = 0

          users_ids = Order.bought.reduce([]) do |acc, order|
            acc << order&.user&.id
          end

          User.where(:_id.in => users_ids).order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end

  end
end
