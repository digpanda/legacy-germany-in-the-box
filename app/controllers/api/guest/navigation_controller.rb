class Api::Guest::NavigationController < Api::ApplicationController

  def show
  end

  def update
    history = navigation.store params[:location]
    render status: :ok,
           json: {success: true, datas: history}.to_json
  end

end
