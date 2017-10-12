class Api::Admin::ChartsController < Api::ApplicationController
  authorize_resource class: false

  def total_users
    render status: :ok,
          json: { success: true, data: total_users_hash }.to_json
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

  private


    # NOTE : need to make a service for this.
    def total_users_hash
      sample
    end
end
