class Api::Guest::NavigationController < Api::ApplicationController
  def show
    render status: :not_found,
           json: throw_error(:resource_not_found).to_json
  end

  def update
    history = navigation.store(params[:location])
    render status: :ok,
           json: { success: true, datas: history }.to_json
  end
end
