class Api::Guest::CartController < Api::ApplicationController

  def total
    render status: :ok,
           json: {success: true, datas: cart_manager.products_number}.to_json
  end

end
