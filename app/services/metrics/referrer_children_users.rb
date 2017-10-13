class Metrics < BaseService
  class ReferrerChildrenUsers < Base

    def settings
      {
        title: '# of Children Users',
        type: :line,
        vertical_label: 'Volume'
      }
    end

    def render
      draw(:children_per_week, label: 'Children per week', color: :blue)

      chart.render
    end

    private

      def referrer
        @referrer ||= Referrer.find(metadata["referrer_id"])
      end

      def children_per_week
        @children_per_week ||= begin
          referrer.children_users.order(parent_referred_at: :asc).group_by do |user|
            user.c_at.strftime('Week %Y-%W')
          end.reduce({}) do |acc, group|
            acc.merge({"#{group.first}": group.last.count})
          end
        end
      end

  end
end
