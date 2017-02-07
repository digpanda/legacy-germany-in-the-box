class Api::Guest::CartController < Api::ApplicationController

  def total
    SlackDispatcher.new.message("TOTAL API SESSION STATE `#{session.id}` : #{session["previous_urls"]}")
    render status: :ok,
           json: {success: true, datas: cart_manager.products_number}.to_json
  end

end
