class Guest::SearchController < ApplicationController

  def show
    @products = Product.can_show.full_text_search(query, match: :all, allow_empty_search: true)
  end

  private

  def query
    params.require(:query) if params[:query].present?
  end

end
