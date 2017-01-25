class Guest::SearchController < ApplicationController

  def show
    @products = Product.all
  end

  private

  def query
    params.require(:query)
  end

end
