class Metrics < BaseService
  class TotalInquiries < Base

    def settings
      {
        title: '# of Inquiries',
        type: :bar,
        vertical_label: 'Volume'
      }
    end

    def render
      draw(:new_inquiries_per_month, label: 'New inquiries', color: :light)
      draw(:total_inquiries_per_month, label: 'Total inquiries', color: :blue, type: :line)
      draw(:total_paid_inquiries_per_month, label: 'Paid inquiries', color: :red, type: :line, fill: false)

      chart.render
    end

    private

      # NOTE : metrics must have a format such as {'Entry 1' => 1, 'Entry 2' => 2}
      # this norm will be automatically understood and drawn by the system.
      # all the database request are made here

      def new_inquiries_per_month
        @new_inquiries_per_month ||= begin
          Inquiry.all.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            acc.merge({"#{group.first}": group.last.count})
          end
        end
      end

      def total_inquiries_per_month
        @total_inquiries_per_month ||= begin
          counter = 0
          Inquiry.all.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end

      def total_paid_inquiries_per_month
        @total_paid_inquiries_per_month ||= begin
          counter = 0
          Inquiry.bought.order(c_at: :asc).group_by do |user|
            user.c_at.strftime('%Y-%m')
          end.reduce({}) do |acc, group|
            counter += group.last.count
            acc.merge({"#{group.first}": counter})
          end
        end
      end

  end
end
