class Guest::SearchController < ApplicationController
  before_filter do
    restrict_to :customer
  end

  def show
    @products = Product.can_show.full_text_search(query, match: :any, allow_empty_search: true)
  end

  private

    def query
      params.require(:query) if params[:query].present?
    end
end
