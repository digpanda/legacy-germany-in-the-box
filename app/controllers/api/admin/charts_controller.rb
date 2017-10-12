class Api::Admin::ChartsController < Api::ApplicationController
  authorize_resource class: false

  def total_users
    render status: :ok,
          json: { success: true, data: total_users_hash }.to_json
  end

  private

    def total_users_hash
      # user creation per month
      new_users_per_month = User.all.group_by do |user|
        user.c_at.strftime('%Y-%m')
      end.reduce({}) do |acc, group|
        acc.merge({"#{group.first}": group.last.count})
      end

      # total users per month
      counter = 0
      total_users_per_month = User.all.group_by do |user|
        user.c_at.strftime('%Y-%M')
      end.reduce({}) do |acc, group|
        counter += group.last.count
        acc.merge({"#{group.first}": counter})
      end

      # chart generation
      chart = Chart.new(title: '# of Users', type: :bar)

      draw = chart.draw(color: :light, label: 'New users')
      new_users_per_month.each do |metric|
        draw.data(position: metric.first, value: metric.last)
      end
      draw.store

      draw = chart.draw(color: :blue, label: 'Total users', type: :line)
      total_users_per_month.each do |metric|
        draw.data(position: metric.first, value: metric.last)
      end
      draw.store

      chart.render
    end

    def sample
      chart = Chart.new(title: 'Title', type: :bar)
      draw = chart.draw(color: :green, label: 'Label 1')
      draw.data(position: 'Week 1', value: 20).data(position: 'Week 2', value: 5).data(position: 'Week 3', value: 35)
      draw.store
      draw = chart.draw(color: :red, label: 'Label 2', type: :line, fill: true)
      draw.data(position: 'Week 0', value: 15).data(position: 'Week 2', value: 30)
      draw.store
      chart.render
    end
end
