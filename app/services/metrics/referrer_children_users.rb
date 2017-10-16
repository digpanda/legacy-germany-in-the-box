class Metrics < BaseService
  class ReferrerChildrenUsers < Base

    def settings
      {
        title: '# of Children Users',
        type: :bar,
        vertical_label: 'Volume'
      }
    end

    def render
      draw(:children_per_week, label: 'Children per week', color: :light)
      draw(:total_children_per_week, label: 'Total children', type: :line, color: :blue)

      chart.render
    end

    private

      def referrer
        @referrer ||= Referrer.find(metadata["referrer_id"])
      end

      def children_per_week
        @children_per_week ||= begin
          referrer.children_users.order(parent_referred_at: :asc).group_by do |user|
            user.c_at.strftime('%Y : Week %W')
          end.reduce({}) do |acc, group|
            acc.merge({"#{group.first}": group.last.count})
          end
        end
      end

      def total_children_per_week
        @total_children_per_week ||= begin
          counter = 0
          referrer.children_users.order(parent_referred_at: :asc).group_by do |user|
            user.c_at.strftime('%Y : Week %W')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end
  end
end
