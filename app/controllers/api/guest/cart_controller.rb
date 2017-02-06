class Api::Guest::CartController < Api::ApplicationController

  def yo
    render status: :ok,
           json: {success: true, datas: cart_manager.products_number}.to_json
  end

end
