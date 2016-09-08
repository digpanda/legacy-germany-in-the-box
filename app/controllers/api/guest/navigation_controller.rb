class Api::Guest::NavigationController < Api::ApplicationController

  def show
  end

  def update
    history = navigation.store params[:location], :except => %w(/users/sign_in /users/sign_up /users/password/new /users/password/edit /users/confirmation /users/sign_out)
    render status: :ok,
           json: {success: true, datas: history}.to_json
  end

end
