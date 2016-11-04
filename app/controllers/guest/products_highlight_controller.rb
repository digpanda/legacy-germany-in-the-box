class Guest::ProductsHighlightController < ApplicationController

  attr_reader :products

  def show
    @products = Product.with_highlight
  end

end
