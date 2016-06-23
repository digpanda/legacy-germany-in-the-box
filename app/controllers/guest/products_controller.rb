class Guest::ProductsController < ApplicationController

  load_and_authorize_resource
  before_action :set_product

  attr_reader :product
  # Nothing yet (go to /api/)

  private
  
  def set_product
    @product = OrderItem::find(params[:id]) unless params[:id].nil?
  end

end