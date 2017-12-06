class Api::Admin::CurrencyRatesController < Api::ApplicationController
  authorize_resource class: false

  # NOTE : `chart` is matching with the current metric we want such as total_users or total_orders
  # which is defined in the URL
  # To setup new charts and metrics, go into `/services/metrics` and create new subclasses for it
  def show
    if valid_params?
      render status: :ok,
            json: { success: true, data: Metrics.new(chart, metadata).render }.to_json
    else
      render json: { success: false, error: 'Paramters invalid.' }
    end
  end

  private

  def valid_params?
    true
  end

end
