class Metrics < BaseService
  class ReferrerChildrenUsers < Base

    def settings
      {
        title: '# of Payments',
        type: :line,
        vertical_label: 'Volume'
      }
    end

    def render
      draw(:children_per_week, label: 'Children per week', color: :light)

      chart.render
    end

    private

      def children_per_week
        @children_per_week ||= begin
          binding.pry
          OrderPayment.where(status: :success).order(c_at: :asc).group_by do |user|
            user.c_at.strftime('Week %Y-%W')
          end.reduce({}) do |acc, group|
            acc.merge({"#{group.first}": group.last.count})
          end
        end
      end

  end
end
