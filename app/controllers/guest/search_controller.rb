class Guest::SearchController < ApplicationController

  def show
    @products = Product.full_text_search(query)
  end

  private

  def query
    params.require(:query) if params[:query].present?
  end

end
