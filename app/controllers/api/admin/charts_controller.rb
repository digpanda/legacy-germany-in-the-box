class Api::Admin::ChartsController < Api::ApplicationController
  authorize_resource class: false

  # NOTE : `chart` is matching with the current metric we want such as total_users or total_orders
  # which is defined in the URL
  # To setup new charts and metrics, go into `/services/metrics` and create new subclasses for it
  def show
    if valid_chart?
      render status: :ok,
            json: { success: true, data: Metrics.new(chart).render }.to_json
    else
      render json: { success: false, error: 'Chart not found.' }
    end
  end

  private

    # NOTE : please add the new charts from Metrics in this array
    # otherwise it won't pass
    def valid_chart?
      [:total_orders, :total_users, :total_payments, :total_referrers].include? chart
    end

    def chart
      params[:id].to_sym
    end

    # NOTE : this is currently not in use
    # but it's a good working sample of the Chart class
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
